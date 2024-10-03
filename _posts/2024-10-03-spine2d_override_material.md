---
title:  "Spine에서 실시간으로 material 변경하기"

categories: [Unity]
tags:
  - [Unity, Spine]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-10-03
---
유니티 게임개발 시 많이 사용되는 [Spine](https://ko.esotericsoftware.com/spine-in-depth)에서 스파인 애니메이션 중에 실시간으로 메테리얼을 교체해야 하는 이슈가 있었다.<br>

맨 처음에는 평범하게 유니티 `Mesh Renderer`에서 직접 `material`을 변경해봤다.

```csharp
obj.GetComponent<MeshRenderer>().material = newMaterial; // 단일 메테리얼일 때
obj.GetComponent<Renderer>().materials = new Material[2] {newMaterial, newMaterial}; // 여러 개의 메테리얼을 교체할 때
```
> [유니티(Unity) Materials 일부 변경하기](https://eunujini.tistory.com/10)

하지만 실제 게임에서는 효과가 없었다.<br>
아마도 Spine이 애니메이션을 제어하면서 메테리얼도 자체적으로 제어하고 있기 때문이 아닐까 싶어서 따로 검색해 봤다.
역시나 스파인 문제였고, 스파인 라이브러리에는 객체의 메테리얼을 변경(덮어쓰기)할 수 있는 기능이 따로 있었다.

> [Set Skeleton Saturation at runtime](https://ko.esotericsoftware.com/forum/d/17605-set-skeleton-saturation-at-runtime)

> [spine-unity Runtime Documentation](https://ko.esotericsoftware.com/spine-unity-rendering)

적용하는 법은 다음과 같다.

```csharp
		var skeleton = o.GetComponent<SkeletonAnimation>();
		var mat = skeleton.SkeletonDataAsset.atlasAssets[0].PrimaryMaterial;
		skeleton.CustomMaterialOverride.Add(mat, newMaterial);
```

스파인 쪽에 기능이 있을 거라는 생각을 못 하면 한참 헤맬 수 있는 문제였는데, 다행이 직감판정에 성공해서 빠르게 해법을 찾을 수 있었다.
