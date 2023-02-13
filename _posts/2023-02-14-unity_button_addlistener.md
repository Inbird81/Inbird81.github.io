---
title:  "유니티 onClick.AddListener에서 함수 파라미터 전달 문제"

categories: [Unity]
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-02-14
---
유니티에서 버튼에 이벤트 함수를 등록하는 기능을 구현하다가, 파라메터가 있는 함수를 다음과 같이 구현했다.

```csharp
button.onClick.RemoveAllListeners();
button.onClick.AddListener(() => 
  {
    target = table[i];
    RefleshPanel();
  });
```

실행해보니 에러가 발생했고, i에 루프의 최대값이 들어가 있었다.
뭔 일인가 해서 찾아보니 나름 알려진 문제였는지 바로 구글신께서 계시를 내려주셨다.

참조한 자료들은 아래와 같다.

> [[Unity] onClick.AddListener() 함수의 파라미터 전달 문제](https://geukggom.tistory.com/216)

> [유니티 onClick.AddListener에서 함수의 파라미터 전달 문제](https://learnandcreate.tistory.com/852)

다음과 같이 임시 변수를 만들어 처리해야 한다.

```csharp
button.onClick.RemoveAllListeners();
button.onClick.AddListener(() => 
  {
    target = table[i];
    int index = i;
    RefleshPanel(index);
  });
```
참고한 게시물들에는 이유는 적혀 있지 않지만, 디버거를 돌려본 결과 람다식 내부의 처리는 AddListener()의 실행 시점이 아니라 호출 시점에 이루어졌다.
호출 시점에서는 i가 루프를 한바퀴 다 돈 뒤니 루프의 가장 마지막 값(위의 예시에서는 32였다)이 되어 있는 것.

이게 어떤 원리로 처리되는지는 잘 모르겠는데 나중에 알게 되면 따로 포스팅을 올릴 생각이다.