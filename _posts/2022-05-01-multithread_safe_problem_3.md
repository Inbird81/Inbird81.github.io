---
title:  "C#에서 멀티스레드에 안전한 구조 설계 (3)"

categories:
  - C&#35;
tags:
  - [C&#35;]

img_path: /images/
toc: false
toc_sticky: false

date: 2013-3-25
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

앞서 올린 게시물 링크

>[C#에서 멀티스레드에 안전한 구조 설계(1)](/posts/multithread_safe_problem_1)

>[C#에서 멀티스레드에 안전한 구조 설계(2)](/posts/multithread_safe_problem_2)

이전글에서 설명한 안습한 결론에 좌절한 후, 좀 더 빠른 lock-free 구조체가 없을까 하고 뒤지던 도중 ConcurrentQueue라는 걸 발견했습니다.

.net 4 이후 버전에서만 동작하고, 멀티스레드에 대해 안전하다고 하는군요.

설명은 아래 위치에서 볼 수 있습니다.

http://msdn.microsoft.com/ko-kr/library/dd267265(v=vs.100).aspx

Interlocked도 그렇고, C#은 역시 그냥 만들어 놓은거 가져다 쓰는게 최고인 언어인지라 그대로 적용해 보았습니다.
 
```csharp 
public void request2()
{
  queryQueue2.Enqueue(1);
}

public void update2()
{
  int t;

 while (!isEnd || !queryQueue2.IsEmpty)
  {
    if(queryQueue2.TryDequeue(out t))
    m += t;
  }
}
```

그리고 대망의 실행 결과...

![Result](2022-05-01-4.jpg)

테스트5가 ConcurrectQueue를 쓴 결과입니다. 1이 그냥 큐에 락 걸어서 돌린 거고 2는 공유 객체(변수 m) 자체에 락을 걸고 큐를 아예 쓰지 않은 경우.

이것저것 다른 프로그램 띄워놓고 돌린거라 오차가 꽤 크지만, 어쨌든 성능이 확 좋아진 건 확실하군요. 실제 게임 서버 같은 곳에서는 update()에서 처리할 것도 많고 락 걸어야 하는 범위도 넓다는 걸 생각하면 실용성을 생각해도 될 만한 성능인 것 같습니다.

결론<br>
![Result](2022-05-01-5.jpg)

역시 C#은 있는거 가져다 쓰라고 만든 언어입니다...
