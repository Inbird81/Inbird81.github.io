---
title:  "Sketchup 6 SDK에서 색상 구하기"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2009-4-22
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

Sketchup 6 SDK에서 메테리얼의 색상값은 ISkpMaterialPtr->GetColor() 함수로 얻을 수 있다.

이 때 리턴값은 OLE_COLOR인데, 이 타입은 DWORD와 같다.

4바이트의 DWORD값 안에 RGB값이 들어가는데, 안에 들어가는 색상값의 순서가 일반적으로 생각하는 것처럼 RGBA순이 아니라, NBGR순서이다. (여기서 N은 NULL)

그래서 OLE_COLOR에서 RGB를 따로 분리해내기 위해서는 다음과 같이 해야 한다.
 
```c++
  double red, green, blue;

   red = (double)((color << 24) >> 24)/ 255.0;
   green = (double)((color << 16) >> 24) / 255.0;
   blue = (double)((color << 8) >> 24) / 255.0;
```