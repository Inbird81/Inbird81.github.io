---
title:  "using과 try catch finally의 차이점"

categories: [C&#35;]
tags:
  - [C&#35;]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-08-27
---
파일 관리 코드를 짜다가 `using`과 `try`-`finally`구문이 기능적으로 비슷하다는 생각이 들어서 한번 구글링을 해봤다.
그리고 재미있는 사실을 알게 되었는데, `using`과 `try`-`finally`는 동일한 기능일 뿐 아니라 컴파일러 레벨에서도 동일한 결과물을 작성한다는 것이다.
대신 `using`은 블록이 끝날 때 자체적으로 Dispose를 호출하고 이를 보장하며, `finally`는 종료시 처리할 구문을 커스터마이징할 수 있다는 차이가 있다. 즉, `finally`구문 내에서 Dispose를 호출할 경우 둘은 실질적으로 동일한 기능을 수행한다.

아래는 참고한 자료들.
> [C# using과 try catch finally의 차이점](https://spaghetti-code.tistory.com/49)

> ['using' statement vs 'try finally'](https://stackoverflow.com/questions/278902/using-statement-vs-try-finally)

사소하지만 C#을 꽤 오래 쓰면서도 모르고 있던 부분이라 기록해둔다.