---
title:  "[C#] ?, ??, ??="

categories:
  - C&#35;
tags:
  - [C&#35;]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-06-12
---

C#은 버전이 올라가면서 계속 유용한 기능들을 새로 추가하고 있는데, 편리하긴 하지만 그만큼 알아야 할 게 늘어나는 문제점도 있다.

그리고 이런 언어 기능들을 사용하다 보면 코드는 간단해지지만, 이게 C언어가 맞나 싶은 형태의 코드가 늘어나게 된다. 
대표적인 게 linq나 람다식(Lambda Expression) 같은 것들.

그리고 최근에 알게 된 게 널 조건 연산자(Null-conditional operators)다.

C#도 결국 C 베이스 언어라 null 체크를 할 일이 엄청나게 많은데, 이 연산자는 그 작업을 간략화시켜 준다.

이건 잘 설명해놓은 글이 많으므로, 내가 참고한 포스트들을 정리한다.

> [C# 메모. 널 조건 연산자(Null-conditional operators)](https://blog.hexabrain.net/315)

> [널 조건 연산자 (Null-conditional operator)](https://www.csharpstudy.com/CS6/CSharp-null-conditional-operator.aspx)

> [연산자 ?? 및 ??=](https://velog.io/@jinuku/C-%EB%B0%8F-.-%EC%97%B0%EC%82%B0%EC%9E%90)

> [MSDN ?? 및 ??= 연산자(C# 참조)](https://docs.microsoft.com/ko-kr/dotnet/csharp/language-reference/operators/null-coalescing-operator)

상세한 내용은 링크한 포스트들 쪽에 잘 정리되어 있으므로 간단한 사용법만 적어본다.

예를 들어 아래와 같은 null 체크 코드가 있다고 하자.

```csharp
UserClass class1;

// case 1
if(class1 != null)
  ret = class1.foo();
else
  ret = null;

// case 2
if(class1 != null)
  retInt = class1.fooInt();
else
  ret = 0;
```

`case 1`은 다음과 같이 간략화할 수 있다
```csharp
ret = class1?.foo(); // ?.는 피연산자가 null이면 null을, 아니면 결과를 반환한다.
```

`case 2`는 다음의 두 가지 방법으로 간략화할 수 있다
```csharp
// nullable 타입을 사용
int? retInt = class1?.fooInt();
// ??= 연산자는 왼쪽 피연산자가 null일 때만 오른쪽 값을 대입한다.
retInt ??= 0;

// ?? 연산자는 왼쪽 피연산자가 null이면 오른쪽, 아니면 왼쪽 값을 반환한다.
int retInt = class1?.fooInt() ?? 0;

```

매우 편리하고 좋긴 한데, 이걸 쓰면 코드에 ?가 난무하게 된다.

당장 NSDN에 이런 예시 코드가 있다.
```csharp
a ?? (b ?? c)
d ??= (e ??= f)
```

![몰루](question.jpg)

이게 뭔 경상도에서 가가 가가 가가가 하는 것도 아니고...

유용하긴 한데 무슨 방언같아서 참 보기 뭐하다.

그리고 개인적으로 C# 코딩할 때 매번 ContainsKey()를 호출하느라 가장 귀찮았던 Dictionary의 값 체크는 인덱스에 해당하는 값이 없으면 걍 exception을 뱉기 때문에 이걸로도 해결이 안 될 것 같다.

