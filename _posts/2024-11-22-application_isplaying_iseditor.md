---
title:  "Application.isPlaying과 Application.isEditor의 차이"

categories: [Unity]
tags:
  - [Unity]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2024-11-22
---
 `Application.isPlaying`은 빌드된 게임 혹은 에디터의 플레이 모드(에디터에서 실행시키는 것)일 때 true를 반환한다.

 `Application.isEditor`는 에디터에서 실행되는지의 여부를 반환한다.

 > [Application.isPlaying](https://docs.unity3d.com/ScriptReference/Application-isPlaying.html)<br>
 > [Application.isEditor](https://docs.unity3d.com/ScriptReference/Application-isEditor.html)

 그리고 `Application.isEditor`는 `#if UNITY_EDITOR`와 기능적으로 동일하며, 코드가 빌드에 포함되는지의 차이만 있다.

 > [Difference between #if UNITY_EDITOR and Application.isEditor?](https://discussions.unity.com/t/difference-between-if-unity_editor-and-application-iseditor/918320)

 즉 에디터에서 Play 버튼을 눌러서 에디터 내의 플레이 모드로 실행했을 경우, `Application.isPlaying`과 `Application.isEditor`는 둘 다 true를 반환한다.<br>
 하지만 게임 실행 중이 아닐 때 동작하는 코드에 대해서는 `Application.isPlaying`는 false, `Application.isEditor`는 true를 반환한다.

```c#
public class NewScriptableObjectScript : ScriptableObject
{
	private void Awake()
	{
		Debug.Log("Called Awake()");
#if UNITY_EDITOR
		Debug.Log("UNITY_EDITOR");
		if (!Application.isPlaying)
		{
			Debug.Log("Application.isPlaying");
		}
#endif
	}
}

public class Test : MonoBehaviour
{
	void Start()
	{
		ScriptableObject.CreateInstance(typeof(NewScriptableObjectScript));
	}
}
```
 위의 코드를 실행해보면 결과는 다음과 같다.

![결과](241122_1.jpg)

 `Application.isEditor`나 `#if UNITY_EDITOR`는 에디터에서 플레이 모드 실행시에도 조건을 만족하는 것으로 판정하므로, 실행시 동작하지 않는(예를 들어 ScriptableObject의 `Awake()`나 `OnEnable()`가 에디터에서만 동작하고 게임 실행 단계에서는 동작하지 않기를 원하는 경우 등) 코드를 지정하려면 `Application.isPlaying`을 사용해야 한다.

 사실 유니티 API사이트 보면 금방 알 수 있는 건데 모르고 있다가 최근에 알게 되서 정리했다.