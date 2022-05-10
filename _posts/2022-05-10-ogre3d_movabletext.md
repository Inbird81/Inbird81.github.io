---
title:  "Ogre3D MovableText 관련해서 원인불명의 삽질"

categories:
  - C++
tags:
  - [C++, Ogre3D]

img_path: /images/
toc: false
toc_sticky: false

date: 2009-5-1
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

다음과 같이 MovableText를 업데이트하는 코드를 짰더니 제대로 갱신이 이루어지지 않았다.

```c++
.
.
MovableText* m_text;
SceneNode* textSceneNode;

void CreateText()
{
 m_text = new MovableText(...);
 textSceneNode->attachObject(m_text);
}

void UpdateText()
{
 .
 .
 textSceneNode->detachObject(m_text);
 m_text->setCaption(...);
 textSceneNode->attachObject(m_text);
 .
 .
}
```

거의 한나절 내내 고생한 끝에 주위의 도움을 받아 수정한 부분.

```c++
void UpdateText()
{
 .
 .
 m_text = (MovableText*)(textSceneNode->getgetAttachedObject(0)); // 추가된 부분
 textSceneNode->detachObject(m_text);
 m_text->setCaption(...);
 textSceneNode->attachObject(m_text);
 .
 .
}
```

Ogre3D 엔진 내부에서 포인터의 위치를 바꾸거나 자체적으로 사본을 생성하는 걸까? 실제로 디버거를 돌려보면 m_text->setCaption() 이 수행되기는 하지만 이상한 위치로 가버렸다.

가장 가능성이 높은 것은 DLL과 얽힌 문제라는 건데, 지금 코드는 저렇게 써놨지만 실제로는 MovableText 객체는 별도의 DLL에서 생성되고, 그 포인터 정보만 DLL에서 프로그램으로 가져오는 식이다. 이 과정에서 뭔가 메모리 관리 문제로 사본이 생성됐다거나 할 가능성이 있다.

정확한 걸 알고는 싶지만, 회사라는게 궁금증을 푸는 데 시간을 원하는 데로 투자할 수 있는 곳이 아니라는 게 안습..ㅠㅜ; 어쨌든 다음번부터는 미리 생성해 둔 포인터를 믿지 말고 그때그때 getXXXX()계열 함수로 객체 정보를 얻어와서 쓰자... ㅠㅜ