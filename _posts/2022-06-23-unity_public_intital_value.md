---
title:  "[Unity] 의문의 초기화"

categories:
  - Unity
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-06-22
---

작업 중에 간단하게 배열의 초기값을 설정하는 코드를 짰다.

```csharp
  [Header("Items")]
  public List<InventoryItem> playerItems;

  void OnEnable()
  {
    if (items == null)
    {
      // 인벤토리는 기본적으로 Null로 채운다.
      playerItems = Enumerable.Repeat(InventoryItem.Null, InventorySize).ToList();
      Debug.Log("인벤토리 초기화 : " + playerItems.Count);
    } 
  }  
```

그런데 게임을 돌려보니, 저 초기화 코드가 실행되질 않았다.

전체 코드를 몇 번이나 검토해봤지만 이걸 초기화하는 다른 코드는 없었다.

`List`는 class이므로 따로 초기화하지 않으면 반드시 `null`이어야 하는데?

이해할 수 없는 상황에'어딘가에 playerItems에 값을 대입하는 내가 모르는 코드가 있겠지' 하고 한참 동안이나 코드를 뒤지다가, 문득 든 생각에 유니티 인스펙터를 살펴봤다.

![인스펙터](ohh.PNG)

아...

유니티 MonoBehaviour를 상속받아 컴포넌트로 들어가는 클래스에서, public로 선언된 멤버 변수는 인스펙터에 노출되고, 이 과정에서 자동으로 초기화된다. 

이 경우 디폴트 값(`List`의 경우는 빈 배열)이 들어가며 List가 null이 아니게 되어 코드가 실행되지 않았던 것이다.

의외로 실수하기 쉬운 부분인 것 같아 정리해둔다.