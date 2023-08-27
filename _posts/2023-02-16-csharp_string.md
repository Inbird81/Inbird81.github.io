---
title:  "C#의 string은 reference type인가?"

categories: [C&#35;]
tags:
  - [C&#35;]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-02-16
---
C#에서 string은 기본 타입이지만 `int`나 `char`같은 다른 기본 타입들과는 처리가 다르다.

별로 신경쓸 일이 많진 않은데, 그래서 종종 기억해놨다가도 까먹는 일이 있어서 정리해둔다.

**c#의 string은 값 타입(reference type)이며 불변(immutable)이다.**

값 타입이라는 것은 클래스처럼 대입시 값이 복사되지 않고 참조 주소, 즉 포인터가 대입된다는 뜻이다. 
하지만 불변성이므로 string은 값을 변경할 수 없고, 변경할 경우 내부적으로 새로운 string 객체를 생성해 반환한다.

> [How do strings work when shallow copying something in C#?](https://stackoverflow.com/questions/506648/how-do-strings-work-when-shallow-copying-something-in-c)

> [C# - string 타입은 shallow copy일까요? deep copy일까요?](https://www.sysnet.pe.kr/Default.aspx?mode=2&sub=0&detail=1&pageno=0&wid=12488&rssMode=1&wtype=0)

이걸 찾게 된 이유는 스크립트 함수명과 함수가 들어 있는 파일명이 n:1로 대응되는 테이블을 만들 일이 생겼기 때문이었다.
이걸 그냥 `Dictionary<string, string>`으로 구현하면 같은 파일명 문자열이 중복으로 생성되어 낭비가 되므로 다음과 같이 구현했다.

```csharp
Dictionary<string, string> funcFileSet;
HashSet<string> files;

foreach(var pair in orgFuncFileSet)
{
  string fileName = pair.value;
  if(!files.Add(fileName))
    fileName = Files.First(x => x == fileName);

  funcFileSet.add(pair.key, filename);
}
```

`HashSet`은 중복이 허용되지 않으므로 동일한 파일명 string이 중복으로 생성되어 메모리를 낭비하는 걸 막을 수 있다.

다만 성능은 안 좋아보이고 코드 자체도 마음에 들지 않으므로 최적화할 방법을 생각해봐야겠다.