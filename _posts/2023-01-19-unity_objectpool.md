---
title:  "Unity 2021에서 추가된 Object Pool 기능"

categories: [Unity]
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2023-01-19
---
Object Pool이야 유니티에서 가장 잘 알려진 테크닉 중 하나겠지만, 이게 유니티 2021에서 공식 지원되었다는 건 얼마 전에야 알게 되었다.

~~오랫동안~~한동안 슬럼프라서 버리고 살았던 블로그를 다시 활성화시킬 겸 간단하게 정리해본다.

참조한 자료들은 아래와 같다.

> [[Unity] 유니티 공식 지원 오브젝트 풀링](https://wergia.tistory.com/353)

> [Object Pooling 유니티에서 이용하기](https://luv-n-interest.tistory.com/1368)

사실 워낙 간단해서 따로 설명할만한 게 없다.

먼저 오브젝트 풀로 관리될 객체의 클래스에 다음을 추가한다.
```csharp
using UnityEngine;
using UnityEngine.Pool;

public class Rabbit : MonoBehaviour
{
  .
  private IObjectPool<Rabbit> _RabbitPool;
  .
  .
  .
  public void SetPool(IObjectPool<Rabbit> pool)
  {
    _RabbitPool = pool;
  }

  public void DestroyRabbit()
  {
    _RabbitPool.Release(this);
  }
}
```

오브젝트 풀을 관리할 클래스는 다음과 같이 구현한다.

```csharp
using UnityEngine;
using UnityEngine.Pool;

public partial class PoolManager : Singleton<PoolManager>
{
  public GameObject RabbitPrefab;

  public IObjectPool<Rabbit> RabbitPool { get; private set; }

  private void InitPools() // 초기화 때 실행되는 함수
  {
    // 오브젝트 생성, 풀에서 꺼낼 때, 풀로 회수할 때, 풀에서 제거될 때
    // 각각에 대한 이벤트 함수를 등록한다.
    RabbitPool = new ObjectPool<Rabbit>(
      CreateRabbit, OnGetRabbit, OnReleaseRabbit, OnDestroyRabbit);
  }

  // 오브젝트가 생성될 때 실행
  private Rabbit CreateRabbit()
  {
    var rabbit = Instantiate(RabbitPrefab)
                  .GetComponent<Rabbit>();
    rabbit.SetPool(RabbitPool); // 관리 풀을 참조할 수 있게 넘김.
    return rabbit;
  }

  // 풀에서 오브젝트를 꺼낼 때 실행
  private void OnGetRabbit(Rabbit rabbit)
  {
    rabbit.gameObject.SetActive(true);
  }

  // 오브젝트를 풀에 회수할 때 실행
  private void OnReleaseRabbit(Rabbit rabbit)
  {
    rabbit.gameObject.SetActive(false);
  }

  // 오브젝트를 풀에서 제거할 때 실행
  private void OnDestroyRabbit(Rabbit rabbit)
  {
    Destroy(rabbit.gameObject);
  }
}
```

사용법은 다음과 같다.

```csharp
// 풀에서 꺼낼 때. 없으면 알아서 생성해준다.
Rabbit rabbit = GameManager.Instance.RabbitPool.Get();

// 씬에서 제거할 때(즉 풀로 돌려보낼때)
rabbit.DestroyRabbit();
```

오브젝트 풀을 구현하는 건 어렵지 않지만, 유니티가 공식으로 지원하는 데 안 쓸 이유가 없다. C#은 원래 있는 거 쓰는 게 성능 뽑는 가장 쉬운 방법이기도 하고.