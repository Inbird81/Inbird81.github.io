---
title:  "[Unity] new input system에서 키/버튼 중복 문제"

categories: [Unity, Input System]
tags: 
  - [Unity, Input System]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-06-28
---
유니티 [new Input System](https://blog.unity.com/kr/technology/introducing-the-new-input-system)에서 키 입력에 함수를 할당하는 방법은 매우 간단하다.

먼저 Input Action Asset을 설정하고<br>
![Input Action Asset](20220630_1.PNG)

Player Input 컴포넌트에 에셋을 할당하고 연결 방식을 설정한 후<br>
![Player Asset](20220630_3.PNG)
*키 입력을 전달하는 방법은 몇 가지가 있지만, 여기서는 Unity Event를 사용했다.*

이벤트 핸들러를 연결해주면 된다.
![Player Asset](20220630_2.PNG)

이렇게만 하면 짜잔! 하고 키 입력이 동작하지만...

테스트해본 결과 X를 누를 때마다 Placebrick() 함수가 세 번씩 실행되는 현상을 발견했다.
![ㅁㄴㅇㄹ](20220630_5.PNG)

도대체 이 황당한 현상은 뭔가 싶어서 구글링을 해봤고, 나와 같은 문제로 고통받는 사람들을 금방 찾을 수 있었다.

> [Input System Button Triggers Multiple Times](https://answers.unity.com/questions/1746247/input-system-button-triggers-multiple-times.html)

> [button trigger behaviour: "release only" triggers twice!?](https://forum.unity.com/threads/button-trigger-behaviour-release-only-triggers-twice.707036/)

이 문제가 2년째 해결되지 않고 있다고 분노하는 포럼 유저가 인상깊었다.

어쨌든, [Input System 메뉴얼](https://docs.unity3d.com/Packages/com.unity.inputsystem@1.4/manual/Interactions.html)에 따르면 입력에 따른 상호작용의 단계는 4가지가 있다.

|Phase|Description|
|:---|:---|
|`Waiting`|The Interaction is waiting for input.|
|`Started`|The Interaction has been started (that is, it received some of its expected input), but is not complete yet.
|`Performed`|The Interaction is complete.
|`Canceled`|The Interaction was interrupted and aborted.<br> For example, the user pressed and then released a button before the minimum time required for a hold Interaction to complete.

버튼의 경우 `Started`는 버튼을 누르기 시작한 순간, `Performed`는 버튼이 완전히(설정된 임계값 이상의 강도로) 눌러졌을 때, `Canceled`는 버튼에서 손을 뗄 때 발생한다.

그리고 이벤트에 연결된 콜백 함수의 호출은 `Started`, `Performed`, `Canceled` 3가지 각각에 대해 발생한다.

확인을 위해 로그를 찍어 보았다.

```csharp
  public void PlaceBrick(InputAction.CallbackContext value)
  {
    Debug.Log("context : " + value.ReadValue<float>().ToString());
    Debug.Log("start : " + value.started + " / " + "perform : " + value.performed + " / " + "cancel : " + value.canceled);
    .
    .
  }
```

결과 :<br>
![ㅁㄴㅇㄹ](20220630_4.PNG)

value는 입력 강도(얼마나 눌러졌는지)를 나타내는 것 같은데, 키보드의 경우 누르면 1, 떼면 0인 것으로 보인다.

결국 이걸 해결하려면 상태 체크를 해야 한다.

```csharp
if (!value.performed) return; // performed일 때만 동작해야 함. 아니면 버튼 누를 때마다 3번씩 호출된다.
```

조이스틱이나 패드 버튼을 감안해서 범용적으로 동작하도록 설계한 건 알겠는데, 왜 이런 부분을 Input Action Asset 내부에서 설정하지 않고 유저가 코드를 쓰도록 만들어 놨는지 모르겠다.<br>
그냥 단순하게 키보드 입력 받아서 동작하는 기능을 구현하려는 사람에게는 개선이 아니라 개악 아닌가?

