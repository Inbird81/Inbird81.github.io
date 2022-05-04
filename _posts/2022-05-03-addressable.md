---
title:  "[Unity] Addressable에서 동기식(synchronously) 로드"

categories:
  - Unity
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-05-04
---

이번에 만든 게임에서 데이터를 addressable로 묶는 작업을 진행했다.

addressable은 unity의 기존 asset bundle manager를 대신해 만들어진 새 기능이라고 하는데, 사실 나는 에셋번들도 써 본 적이 없으니 이번이 유니티 에셋번들을 처음 다뤄보는 셈이다.

어차피 에셋번들 관련기능은 다 어드레시블로 통합될 것 같은 분위기라 배워둘 겸 이걸로 번들을 관리하기로 했는데, 쓰다 보니 몇 가지 문제가 있었다.

첫째는, 어드레시블이 비동기(asynchronous)로드만을 지원한다는 것이다.

어드레시블 에셋을 로드하는 함수는 LoadAssetAsync()만 있고, 동기식 로드 함수인 LoadAsset()은 삭제되었다.

즉, addressable을 쓰면 프로젝트 전체를 비동기 구조에 맞춰 설계해야 한다는 것이다.

그런 거 생각 안하고 이미 짜둔 코드를 바꾸려고 하면 당연히 재앙이 발생한다.

문제는 이게 기존 에셋번들 매니저를 대체하는 차세대 라이브러리라는 점이다. 즉 기존 에셋번들 매니저는 더 못 쓰고, addressable이 유니티의 표준이므로 무조건 따라갈 수밖에 없다.

당연히 여기에 불만을 가진 사람들은 당연히 엄청 많았다.<br>
아래 링크는 동기식 작업이 가능하던 asset bundle을 쓰다가 날벼락을 맞고 빡친 사람들과 '비동기 구조 그거 별 거 아닌데 왜 그렇게 열내냐'는 인간의 마음을 모르는 프로그래머들이 벌인 키배의 현장이다.

> <https://forum.unity.com/threads/why-are-there-no-synchronously-loadasset-apis.539946/>

장장 3년에 걸친 키배 끝에 결국 유니티 테크놀로지측은 결국 어드레시블에 동기식 로드 기능을 추가하는 것으로 일단 이 문제는 마무리되었다.

문제는 이게 제대로 된 동기 함수가 아니라 그냥 땜빵이라는 거지만.

addressable의 동기 처리는 WaitForComplete() 함수를 통해 이루어진다.
비동기 함수의 handle에서 WaitForComplete()를 실행하면 해당 함수가 완료될 때까지 코드를 더 실행하지 않고 대기하는 식이다.

```csharp
void Start()
{
    //Basic use case of forcing a synchronous load of a GameObject
    var op = Addressables.LoadAssetAsync<GameObject>("myGameObjectKey");
    GameObject go = op.WaitForCompletion();

    //Do work...

    Addressables.Release(op);
}
```

출처 :
> <https://docs.unity3d.com/Packages/com.unity.addressables@1.19/manual/SynchronousAddressables.html>

써본 결과 (당연히)정상적으로 동작했고, 실질 동기식 로드인 것처럼 처리할 수 있었다. 덕분에 어드레시블을 적용하다 개판이 될 뻔 한 프로젝트도 정상적으로 마무리할 수 있었다.

이게 2021년에 나왔으니 망정이지 더 늦었으면 진짜 x될 뻔한 상황이었다.

문제는, 이 함수에는 이런 설명이 붙어 있다는 점이다.

> All currently active Asset Load operations are completed when <b>WaitForCompletion</b> is called on any Asset Load operation, due to how Async operations are handled in the Engine. To avoid unexpected stalls, use <b>WaitForCompletion</b> when the current operation count is known, and the intention is for all active operations to complete synchronously.

에셋을 로드하는 중에 WaitForCompletion()이 호출되면, 현재 진행중인 '모든' 비동기 에셋 로딩이 끝날 때까지 대기한다는 내용이다.

그러니까 비동기로 에셋 여러 개를 동시에 로드하면서, 그 중 필요한 것만 동기식으로 불러들일 수가 없다. 에러는 나지 않겠지만 비동기 로드 전부가 대기를 타버리기 때문에 지연이 발생할 수 있다.

내가 만들고 있는 게임이야 이걸로 문제가 생길 여지는 거의 없지만, 2022년 5월 현재 최신버전인 1.19에서도 동일하게 명시되어 있는 내용이므로 사용시 주의할 필요가 있어 보인다.