---
title:  "Unity에서 복잡한 Prefab의 Bound를 얻는 방법"

categories: [Unity]
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-03-31
---
사용중인 에셋이 객체의 Bound를 얻는 부분을 다음과 같이 처리하고 있었다.

```csharp
Mesh mesh = voxel.mesh;
Bound bounds = mesh.Bounds;
```

이렇게 하면 prefab에 자식 오브젝트가 붙어있거거나 scale이 조정되어 있는 경우 제대로 인식할 수 없어 복잡한 프리팹의 경우 bound가 이상하게 잡히게 된다.

이런 경우 전체 프리팹의 정확한 bound를 얻는 코드는 다음과 같다.

```csharp
Bounds _bound;
public Bounds bounds
{ 
  get 
  {
    if (_bound.size == Vector3.zero && prefab != null)
    {
      Renderer[] renderers = prefab.GetComponentsInChildren<Renderer>();
      if (renderers.Length > 0)
      {
        _bound = renderers[0].bounds;
        for (int i = 1, ni = renderers.Length; i < ni; i++)
        {
          _bound.Encapsulate(renderers[i].bounds);
        }
      }
    }
    return _bound; 
  }
}
```

아래는 참고한 자료들.
> [Bounds 살펴보기](https://nforbidden-fruit.tistory.com/41)

> [Getting the total bounds of a Prefab with Multiple Children.](https://www.reddit.com/r/Unity3D/comments/30y46p/getting_the_total_bounds_of_a_prefab_with/)

일단 이 코드가 정상동작하는 것은 확인했다.

이게 최적화된 코드인지는 모르겠지만 어차피 내부적으로 메쉬나 스케일이 변경되지 않는 한 bound도 바뀌지 않으므로, 처음 호출될 때 한 번만 계산한다면 성능 문제는 거의 없을 것 같다.