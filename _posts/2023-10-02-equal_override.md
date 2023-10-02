---
title:  "C#에서 equals와 ==의 차이"

categories: [C&#35;]
tags:
  - [C&#35;]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-10-02
---
C#에서 특정한 개체가 동일한지를 체크하는 방법은 `object.equals()`를 사용하는 것과 `==`연산자를 사용하는 것 두 가지가 있다.<br>
그리고 이 둘은 따로 오버라이딩이 가능하다.

이 둘은 얼핏 보면 같은 기능처럼 보이지만, 사실 다른 기능이다.

> [C# 에서의 문자열 비교, == or Equals?](https://hanavy.tistory.com/10)

> [C# difference between == and Equals()](https://stackoverflow.com/questions/814878/c-sharp-difference-between-and-equals)

요약하자면 `object.equals()`는 값을 비교하고, `==`연산자는 동일 객체의 참조인지를 확인하는 `System.Object.ReferenceEquals()`함수를 호출한다.<br>
보통 관성적으로 `==`를 이용해 값을 비교하게 되는데, 이 경우 연산자 오버로딩을 해줘야 한다.<br>
오버로딩을 한 객체라도 그걸 `object`타입 레퍼런스로 받아서 쓸 경우 디폴트 연산자가 사용되므로 주의하고, 가장 좋은 건 `==`를 동일 객체의 참조 여부 확인에만 쓰는 버릇을 들이는 것 같다.