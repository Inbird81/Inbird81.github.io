---
title:  "UI Text, TextMeshPro, TextCore?"

categories: [Unity]
tags:
  - [Unity, Testmeshpro]

img_path: /images/
toc: true
toc_sticky: true
 
date: 2024-11-16
---

최근에 [유니티 6](https://unity.com/kr/releases/editor/whats-new/6000.0.22#notes)을 사용해봤는데, 생성할 수 있는 객체 중에 `TextMeshpro`와 `TextCore`라는 게 나눠져 있었다.

![textcore](20241116_1.jpg)

`TextMeshpro`는 현 시점(유니티 6 프리뷰)에서는 별도의 패키지지만 사용할 때 자동으로 다운받는 창이 뜨는 구조였고, 기존 `UI Text`는 역시 남아 있지만 legacy로 분류되어 있다.<br>
이게 뭔지 몰라서 찾아본 바로는, 공식적인 답변은 아니지만 `TextCore`가 `TextMeshpro`를 기본 텍스트 기능으로 통합한 것이라고 한다. <br>
그럼 이게 왜 `TextMeshpro`와 따로 존재하는가?<br>
아직 통합 작업이 끝나지 않아서라는 게 내가 찾은 답변이었다. 현 시점에는 통합이 완전하지 않아서, 유니티의 UI Element에서는 `TextCore`를 쓰고 UGUI에서는 `TextMeshPro`를 쓰는 것 같다. 그런 주제에 둘 다 메뉴에는 들어가 있어서 사람을 헷갈리게 만든다.<br>
그래서 뭘 써야 아는지 모르겠지만 일단 UI Element가 아닌 게임 내 오브젝트에서는 `TextCore`를 무시하고 `TextMeshPro`만 쓰기로 했고, 그걸로 별 문제 없이 돌아가고 있다.<br>

유니티의 preview 버전은 beta가 아닌데 이런 식으로 개발중인 기능을 헷갈리게 넣어놓은 건, 최근 유니티가 유저 편의성보다 개발진이 넣고 싶은 기능 추가에만 열을 올린다는 비판이 왜 나오는지 조금 알 것 같은 기분이다.