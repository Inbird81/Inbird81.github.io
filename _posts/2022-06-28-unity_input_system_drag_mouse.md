---
title:  "[Unity] new input system 에서 drag 쉽게 구현하기"

categories: [Unity, Input System]
tags: 
  - [Unity, Input System]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2022-06-28
---
작업중이던 프로젝트의 입력 컨트롤을 유니티의 [new Input System](https://blog.unity.com/kr/technology/introducing-the-new-input-system)으로 교체했다.

그리고 최근에, 마우스 버튼을 누른 상태로 드래그해서 시점을 전환하는 기능을 구현하려고 했다.

구글링을 해보니 코드를 쓰는 방법이 이것저것 나와 있는데, Modifier 기능을 사용하면 코드 없이도 Input Action Asset 내에서 설정만으로 두 개 이상의 키를 조합할 수 있다.

방법은 간단하다.

![우클릭](playerinput_rightclick.png)
<br>이렇게 우클릭해서

![인스펙터](playerinput_setting.png)
<br>이렇게 설정하면 된다.

내가 검색을 잘 못해서인지 의외로 잘 나와있지 않은 방법이라 따로 정리한다.

출처 : <https://forum.unity.com/threads/simple-mouse-drag.805266/>

마우스 클릭이 설정된 행동이 여러 개가 있을 경우(예를 들어 마우스 우클릭 상태로 드래그해서 시점 전환 - 마우스 우클릭으로 상호작용) 유니티 엔진 특성상 문제가 생길 수 있다고 하는데, 아직은 이 문제를 신경쓸 일은 없을 것 같다.