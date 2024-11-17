---
title:  "ScriptableObject를 참조하는 객체의 JSON Serialize"

categories: [Unity]
tags:
  - [Unity, ScriptableObject]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2024-11-16
---

 Unity의 `ScriptableObject`는 특정한 아이템 유형 등을 정의할 때 Enum처럼 사용할 수 있다. 이는 유니티에서 공식적으로 권장하는 사용 방식이다.

![Sample](20241116_4.png)

 위의 인벤토리 예시는 유니티에서 제공하는 [협업과 코딩 측면에서 유용한 스크립터블 오브젝트 활용법 6가지](https://unity.com/kr/blog/engine-platform/6-ways-scriptableobjects-can-benefit-your-team-and-your-code)라는 강좌에 있는 내용이다.

 여기까지는 괜찮지만, 문제는 이 인벤토리 정보를 저장하려고 할 때 발생한다.
 유니티에서 가장 일반적으로 사용되든 게임 데이터 저장방법은 Json이다. 위의 예시와 유사한 코드를 만들어서 세이브를 구현해보자.

```c#
using UnityEngine;

public class ItemTemplete : ScriptableObject
{

}

public class InventoryTest : MonoBehaviour
{
	public ItemTemplete Weapon;
	public ItemTemplete Armor;

  void Start()
  {
    Save();
  }

	void Save()
	{
		var str = JsonUtility.ToJson(this);
		Debug.Log(str);
	}
}
```

 인스펙터에서는 이렇게 설정한다.

![inspector](20241116_3.jpg)

 그리고 실행해 보면 json으로 변환된 출력 결과를 볼 수 있다.

![log](20241116_2.jpg)

 ScriptableObject 타입인 Armor의 값에 `Instance ID`가 들어있는 것을 볼 수 있다.<br>
 이 인스턴스 ID가 지정한 ItemTemplete의 참조라고 볼 수 있다.<br>
 문제는, `Instance ID`는 게임을 재시작하면 바뀌는 값이라는 것이다.

 유니티 메뉴얼에는 다음과 같이 적혀 있다.<br>

> ID는 플레이어 런타임과 편집기의 세션 간에 변경됩니다. 따라서 ID는 세션 간에 걸쳐 발생할 수 있는 작업(예: 파일에서 객체 상태 로드)을 수행하는 데 신뢰할 수 없습니다.
> The ID changes between sessions of the player runtime and Editor. As such, the ID is not reliable for performing actions that could span between sessions, for example, loading an object state from a file.
- [https://docs.unity3d.com/ScriptReference/Object.GetInstanceID.html](https://docs.unity3d.com/ScriptReference/Object.GetInstanceID.html)

 그러니까 이 방식으로 인벤토리 데이터를 저장하면 Armor값은 다음 로드할 때 날아간다는 것이다.

 그럼 이 문제는 어떻게 해결해야 하는가?<br>
 상식적으로 ScriptableObject는 유니티가 미는 주요 기능이니까 뭔가 해결 방법이 있을 것이다...<br>
 라고 생각했지만, 구글을 한참 뒤져도 이 문제를 해결하는 '유니티의 자체 기능'은 없었다. 어떤 형태로든 SO에 대한 참조를 저장하지 않고 우회하는 구조를 만들라는 이야기가 대부분. 참조를 직렬화하기 어려운 건 원래 그랬지만 SO는 고정된 에셋인데도 그렇다.<br>
 SO에 고유 ID를 할당하고 매니저 클래스에서 ID로 참조, 세이브 파일에는 ID값만 넣는 식으로 충분히 구현 가능하지만, 유니티는 이런 기능을 공식적으로 지원하지 않으며, 사용자가 직접 구현해야만 한다.<br>
 이와 관련된 불편을 호소하는 사람들은 나 혼자가 아닌지, 관련글을 꽤 많이 찾을 수 있었다.
 
 > [Save List of Scriptable objects](https://discussions.unity.com/t/save-list-of-scriptable-objects/848395)<br>
 > [Serializing References to ScriptableObjects](https://stackoverflow.com/questions/75682909/serializing-references-to-scriptableobjects)<br>
 > [Serializing ScriptableObject Reference (InstanceID)](https://stackoverflow.com/questions/61698052/serializing-scriptableobject-reference-instanceid)

 Reference Type을 저장하는 건 복잡한 문제니까 그렇다 쳐도, 최소한 ScriptableObject에 대해서만이라도 지원해주는 게 맞지 않나? 아이템 같은 걸 SO로 구현하는 건 상당히 일반적인데, 인벤토리를 저장할 방법 정도는 게임에서 지원해야지...<br>
 ScriptableObject이나 그 이후에 추가된 기능들을 보면 유니티가 추가하는 신기능들은 뭔가 나사가 하나씩 빠져있는 느낌이 든다.