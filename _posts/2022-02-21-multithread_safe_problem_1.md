---
title:  "C#에서 멀티스레드에 안전한 구조 설계 (1)"

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

최근에 C#으로 서버를 짜보고 있는지라 멀티스레드 안전성에 대해 이것저것 찾아봤습니다.   
일단 당연하다면 당연한 말이지만, C# event 호출은 스레드와 동일하게 취급되므로 그 자체로는 멀티스레드 안전성을 보장하지 않습니다.
 
```csharp
namespace ThreadTest
{
  public delegate void updatefunc();
  public class test1
  {
    int m;
    public Queue<int> threadInfoQueue;
    public test1() 
    { 
      m = 0; 
      threadInfoQueue = new Queue<int>();
      // 생성자가 실행된 스레드의 ID를 로그에 기록합니다.
      Thread th = Thread.CurrentThread;
      threadInfoQueue.Enqueue(th.GetHashCode());
    }

    public void setEvent(threadfunc1 t1)
    {
      // 이벤트 핸들러 설정.
      t1.updateEvent += new updatefunc(update);
    }

    public void update() 
    {
      // update()가 실행된 스레드의 ID를 로그에 기록합니다. Enqueue는 멀티스레드에 대해 안전하지 않으므로 lock 필요.
      lock (threadInfoQueue)
      {
        Thread th = Thread.CurrentThread;
        threadInfoQueue.Enqueue(th.GetHashCode());
      }

      m++;
    }

    public int GetResult() { return m; }
  }

  public class threadfunc1
  {
    public event updatefunc updateEvent;
    public void update1()
    {
      updatefunc handler = updateEvent;
      if (handler == null) return;
      // 등록된 이벤트 처리 함수(test1.update())를 실행시킨다.
      for (int i = 0; i < 5; i++) 
        handler();
    }
  }

  public partial class Form1 : Form
  {
    public Form1()
    {
      InitializeComponent();
      test1 t1 = new test1();
      threadfunc1 tf1 = new threadfunc1();
      threadfunc1 tf2 = new threadfunc1();

      // 이벤트 핸들러 등록.
      t1.setEvent(tf1);
      t1.setEvent(tf2);

      Thread counter1 = new Thread(new ThreadStart(tf1.update1));
      Thread counter2 = new Thread(new ThreadStart(tf2.update1));

      // 두 스레드의 ID 출력.
      msgTextBox.AppendText("Counter 1 Thread ID : " + counter1.GetHashCode() + "\n");
      msgTextBox.AppendText("Counter 2 Thread ID : " + counter2.GetHashCode() + "\n");

      counter1.Start();
      counter2.Start();

      // 스레드 종료까지 대기.
      counter1.Join();
      counter2.Join();

      msgTextBox.AppendText("결과 : " + t1.GetResult() + "\n");

      // 로그 출력.
      foreach (int tcode in t1.threadInfoQueue)
      {
        msgTextBox.AppendText("Thread ID : " + tcode + "\n");
      }
    }
  }
}
```
간단한 테스트 예제입니다.   
test1.update()에서 멤버변수를 업데이트하고, 두 개의 다른 스레드에서 update()를 이벤트로 호출합니다. 이 경우 update()는 test1 객체가 생성된 스레드가 아니라, 이벤트를 호출한 스레드에서 실행됩니다.

아래는 실행 결과입니다.

![Result](2022-02-21-1.jpg)

보시는 바와 같이 test1의 생성자는 Thread ID 1에서 호출되지만, update()는 3번과 4번 스레드(즉 update()를 호출하는 두 스레드)에서 실행됨을 알 수 있습니다. 이렇게 되면 그냥 평범한 멀티스레드 구조가 되어, 안전성은 보장되지 않습니다.

쓸데없이 긴 글이지만 요점은 간단합니다.

'이벤트는 그냥 멀티스레드 구조입니다'

뭐 이벤트 자체가 내부적으로 멀티스레드로 구현되어 있다고 하니 당연하다면 당연한 일입니다.

단지 저는 이 당연한 사실을 구글에서도 명확하게 찾을 수가 없어서 직접 테스트 코드를 돌려봐야 했다는 거... ㅠㅜ

2편에서 이어집니다 ( ..)