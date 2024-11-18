---
title:  "Odin Inspector의 PropertyOrder 관련 짧은 팁"

categories: [Unity]
tags:
  - [Unity, Odin]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2024-11-18
---
 Odin Inspector의 [PropertyOrder](https://www.odininspector.com/attributes/property-order-attribute)를 사용하면 인스펙터에서 프로퍼티가 출력되는 순서를 지정할 수 있다. <br>
 유니티에서는 상속된 클래스의 프로퍼티가 인스펙터에서 보이는 순서를 지정할 수 없어서 불편할 때가 많은데 `PropertyOrder`가 이 문제를 해결해준다.

 이때, `PropertyOrder`가 설정되지 않은 일반 프로퍼티의 Order는 0으로 취급되는 것으로 보인다.


```c#
public class GameBaseSO : SavableSO
{
	[PropertyOrder(1)] // PropertyOrder 1
	public string Name;

	[TextArea(5, 20)]
	[PropertyOrder(998)]
	public string HelpText;
}

public class Area : GameBaseSO
{
	[TextArea(5, 20)]
	public string Description;

	public List<AreaTag> Tags;

	public int MaxFacility;
}
```
`PropertyOrder`를 1로 설정하면 `Name`이 Order가 없는 `Description`이나 `MaxFacility`보다 아래에 오는 것을 볼 수 있다.

![결과](241118_1.jpg)

여기서 Name의 `PropertyOrder`를 -1로 바꾸면 `Name`이 `Description`위로 올라오게 된다.

![결과](241118_2.jpg)