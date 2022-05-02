---
title:  "CLI에서 비관리 포인터가 멋대로 사라지는 문제"

categories:
  - C#
tags:
  - [C#]

img_path: /images/
toc: false
toc_sticky: false

date: 2010-1-8
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

C++/CLI 코드
```c++
public ref class Class1
{
  private:
  // TODO: 여기에 이 클래스에 대한 메서드를 추가합니다.
  int* test;
  public:
  Class1()
  {
    Class1(0);
  }

  Class1(int a)
  {
    test = new int[10];
  }
};
```
C# 코드
```csharp
public partial class Form1 : Form
{
    public Form1()
    {
        InitializeComponent();
        Class1 c1 = new Class1();
    }
}
```

위와 같은 코드를 짠 후 C#에서 CLI의 Class1() 생성자를 호출하면, Class(int a) 생성자를 호출한 후 할당된 test 변수의 값이 사라져버린다.<br>
즉 Class1() 생성자가 내부적으로 Class(int a) 생성자를 호출해 test 변수에 배열을 할당하는데, 이 할당된 배열이 Class(int a) 함수에서 빠져나가는 순간 해제되어버린다는 것.

아무래도 GC가 멋대로 포인터에 할당된 메모리를 정리해버리는 것 같은데(분명히 비관리 포인터인데도 그렇다. 관리되는 코드 내에서는 비관리 포인터도 GC가 관리하는 듯 하다.) 어떻게 해야 비관리 포인터의 값이 멋대로 사라지는 걸 막을 수 있는지 모르겠다 -_-;;<br>
(일단은 생성자 연쇄호출을 쓰지 않으면 해제가 일어나진 않는다)