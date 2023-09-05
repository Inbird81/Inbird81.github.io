---
title:  "VS 2005/2008에서 png 파일을 icon 클래스에 등록하는 방법"

categories:
  - C++
tags:
  - [C++]

img_path: /images/
toc: false
toc_sticky: false

date: 2008-12-05
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2022년 현재의 환경과는 맞지 않을 수 있습니다._

아래처럼 직접 png 파일을 icon 클래스에 등록할 수는 없다. 형식이 맞지 않다고 에러를 냄.

```c++
icon = new Icon("test.png")
```

하지만 ImageList 클래스같은 경우 이미지로 Icon 클래스를 사용하므로, 방법이 필요한데..

```c++
IntPtr hIcon = new Bitmap(AllData.projectList[i][3]).GetHicon();
Icon ico = Icon.FromHandle(hIcon);
```

이렇게 핸들을 받아서 등록하면 된다. 딱히 변환을 거치는 구조도 아닌 것 같은데 왜 이렇게 해야 하는지는 의문. 참고로 IconConverter 클래스는 어떻게 쓰는 건지도 모르겠다.

참고: [http://social.msdn.microsoft.com/Forums/en-US/vbgeneral/thread/d0ed79b1-99b3-428d-9163-023d556a6a2d/](http://social.msdn.microsoft.com/Forums/en-US/vbgeneral/thread/d0ed79b1-99b3-428d-9163-023d556a6a2d/)