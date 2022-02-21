---
title:  "C#에서 멀티스레드에 안전한 구조 설계 (2)"

categories:
  - C#
tags:
  - [C#]

img_path: /images/
toc: false
toc_sticky: false

date: 2013-3-24
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

앞서 올린 게시물 링크

>[C#에서 멀티스레드에 안전한 구조 설계(1)](/posts/multithread_safe_problem_1)

>[Lock과 Interlocked.increment의 속도 차이](/posts/interlocked-increment)

사실 결론을 보자면 제목낚시글에 가깝습니다만...

이벤트가 멀티스레드상에서 안전하지 않다는 걸 확인했기 때문에, 안전을 보장하기 위한 방법을 생각해 보았습니다.

제가 생각한 방법은, 외부에서 들어오는 모든 요청을 queue에 저장한 후, 클래스 내부에서 루프를 돌면서 큐에 들어온 요청을 읽어들여 처리하는 것이었습니다. 이렇게 하면 외부 스레드에서 직접 클래스 내부 변수를 건드리는 것이 아니기 때문에 논리적으로는 안전해집니다.

```csharp 
public void setEvent(threadfunc1 t1)
{
  // 이벤트 핸들러 설정.
  t1.updateEvent += new updatefunc(request);
}

public void request()
{
  lock (queryQueue)
  {
    queryQueue.Enqueue(1);
  }
}

void update()
{
  int t;
  while (!isEnd || queryQueue.Count != 0)
  {
    lock (queryQueue)
    {
      if (queryQueue.Count < 1) continue;
      t = queryQueue.Dequeue();
    }

    m += t;
  }
}
```
위와 같은 코드를 작성한 후, 외부 쓰레드에서 이벤트로 request()를 등록합니다.

외부 스레드들이 루프를 돌며 request()를 계속 호출하고, update()도 별도의 스레드에서 무한루프를 돌며 큐에 값이 있으면 읽어들어 업데이트합니다. 이 경우 변수 m 자체는 update() 한 곳에서만 건드리므로 lock이 필요없어집니다.

테스트 코드는 다음과 같습니다.

```csharp
private void button5_Click(object sender, EventArgs e)
{
  test1 t1 = new test1();
  threadfunc1 tf1 = new threadfunc1();
  threadfunc1 tf2 = new threadfunc1();
  Stopwatch sw = new Stopwatch();

  // 이벤트 핸들러 등록.
  t1.setEvent(tf1);
  t1.setEvent(tf2);

  Thread counter1 = new Thread(new ThreadStart(tf1.update1));
  Thread counter2 = new Thread(new ThreadStart(tf2.update1));
  Thread updater = new Thread(new ThreadStart(t1.update));

  msgTextBox.AppendText("테스트 1 시작\n");
  sw.Start(); // 시간체크 시작.
  counter1.Start();
  counter2.Start();
  updater.Start();

  // 스레드 종료까지 대기.
  counter1.Join();
  counter2.Join();

  t1.isEnd = true;
  updater.Join();
  sw.Stop();

  msgTextBox.AppendText("테스트 1 결과 : " + t1.GetResult() + "\n");
  msgTextBox.AppendText("실행시간 : " + sw.ElapsedMilliseconds.ToString() + "ms\n");
}
```
구조는 그럴듯합니다만...

이 경우 결국 request를 저장하는 큐에 lock을 걸어야 하기 때문에, 배보다 배꼽이 더 커지는 사태가 발생합니다 -_-; 게다가 업데이트 스레드 자체도 오버헤드가 걸리기 때문에 성능은 더더욱 나락으로...

게다가 더 골때리는건, lock-free queue 소스를 구해서 적용해본 결과 오히려 더 느려지는 결과가 나왔다는 점입니다.

![Result](2022-02-21-3.jpg)

순서대로 lock-free queue를 쓴 경우, 그냥 큐에 lock을 건 경우, 변수 m을 그냥 lock()으로 감싼 경우, interlocked.increment를 이용한 경우, 마지막으로 락을 걸지 않은 경우입니다. 테스트1이 두번 나온 건 복붙하고 글자 고치는걸 까먹어서...

인터넷상에서 구한 lock-free queue가 이런 케이스에서 성능이 안 나올 수 밖에 없는 구조인지(말이 좋아 락프리지 내부적으로는 결국 락을 거는 곳이 있는데, 그 조건에 많이 걸릴 경우) 아니면 제가 코드를 잘못 짠 건지.... 왠지 후자의 가능성이 걸립니다 -_-;

실제 게임 서버같은 경우 update()에서 처리하는 일이 많을 테니 조금 달라질지 모르겠지만, 이대로면 그냥 노멀하게 객체에 락 걸어가며 쓰는 게 성능상으로는 더 나을 것 같네요.

뭔가 이 구조를 성능저하 없이 구현할 수 있는 다른 방법이 없을까요... 이벤트가 멀티스레드에 안전하지 않으니 결국 풀링을 수동으로 루프 돌려서 할 수 밖에 없다는 게 참...