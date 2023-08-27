---
title:  "Lock과 Interlocked.increment의 속도 차이"

categories:
  - C&#35;
tags:
  - [C&#35;]

img_path: /images/
toc: false
toc_sticky: false

date: 2013-3-24
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

멀티스레드 문제 때문에 이것저것 뒤지던 도중 InterLocked를 써보게 되었는데, 내부적으로 결국 임계영역을 쓰는 방식이라 그냥 lock 거는거랑 별 차이가 없을 거라 생각했습니다.   
하지만 막상 테스트해보니 꽤 차이게 크게 나는군요.

아래 게시물의 이벤트 호출 방식에서 update()를 다음과 같이 바꾼 버전입니다.  
(뭐 버튼같은것도 추가했지만 전체 소스는 필요없겠죠)

```csharp
public void directUpdate1()
{
  lock (lockObject)
  {
    m++;
  }
}

public void directUpdate2()
{
  Interlocked.Increment(ref m);
}
```

![Result](2022-02-21-2.jpg)

테스트2가 directUpdate1()을 호출한 경우고, 테스트3이 directUpdate2() 호출입니다.

보시다시피 속도가 4배 가까이 차이납니다.

x86 릴리즈 빌드에 .net 4버전, 테스트 PC는 듀얼코어입니다. (스레드도 2개)

다른 곳에서 찾아본 바로는 30%정도의 속도 향상이 있다고 하는데, 이렇게 차이가 크게 나는 이유가 뭔지 모르겠네요. .net 버전이 올라가면서 내부적으로 뭔가 lock-free 알고리즘을 써서 최적화된 건지...

어쨌든 이정도면 가능한한 interlocked를 쓰는 게 좋을 것 같습니다. (이게 특이한 케이스라고 해도 보통 30%면 그게 어디야...)