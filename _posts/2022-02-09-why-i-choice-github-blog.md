---
title:  "[Diary] Github 블로그를 선택한 이유와 감상"
excerpt: "Github 블로그를 선택한 게 정말 잘 한 일일까?"

categories:
  - Diary
tags:
  - [Blog, jekyll]

toc: true
toc_sticky: true
 
date: 2022-02-09
last_modified_at: 2022-02-09
---

## Github 블로그를 선택한 이유
*****
기술 블로그(라고 하기도 민망하지만)를 만들기로 결정하고 어떤 플랫폼을 쓸지 꽤 고민했다.

나랑 같은 고민을 한 사람이 꽤 많았는지, 구글링을 해보면 비교글도 많고, ***플랫폼을 고르는 데 너무 오래 고민하지 마라***라는 조언도 있었다.  
그래, 사람 생각하는 게 다 비슷한 법이지... (먼산)
<br><br>

### 기술 블로그 플랫폼별 특징
대충 한나절을 구글신께 기도한 결과 대략적으로 알아낸 각 기술 블로그 플랫폼의 대략적인 특색은 다음과 같다.

- 네이버 블로그 : 기술블로그로는 고려대상이 아님.
- 티스토리(Tistory) : 무난. 많이 씀. 코드블록 지원은 호불호가 갈리지만 쓸만함.
- 미디엄(Medium) : 다 좋은데 한글폰트가 너무 구리고 이 문제를 해결하는 것이 불가능.
- 브런치(Brunch) : 개발블로그에는 적합하지 않고 폐쇄형임.
- 벨로그(Velog) : 개발블로그 특화. 하지만 마이너.
- 워드프레스(Wordpress) : 기능은 많지만 서버 직접 구축하거나 호스팅해야 함.
- 노션(Notion) : 노션 그거 협업툴 아님? 블로그 용도로는 호불호 갈리는 듯.
- 깃허브(github) : 어려움.

처음에 고려했던 것은 무난무난한 티스토리였다.  
이 바닥 트렌드와 너무 오래 떨어져 있어서 거의 IT 원시인 상태로 우가우가하며 하나씩 공부하는 중인 만큼 무난하고 편한 게 좋다고 생각했다.
<br><br>

### 티스토리를 선택하지 않은 이유
하지만 생각이 바뀐 건 이 게시물을 찾으면서였다.

https://unzengan.com/1425
```
블로그 해킹으로 인한 접근 제한 막는 유일한 방법
```

어떤 이유로든 블로그에 문제가 생기면 다음 운영측이 임의로 블로그를 폐쇄할 수 있고, 한번 폐쇄되면 ***안 풀어준다***.

정확히는 대부분의 대형 플랫폼 업체가 다 그렇듯 개인의 문의사항이나 항의는 들은 척도 안 하고 씹거나 매크로 답변만 돌아오는 것이다.  
특히나 다음 고객센터의 [안 듣고 안 보고 정보를 주지 않는](https://namu.wiki/w/%ED%8B%B0%EC%8A%A4%ED%86%A0%EB%A6%AC#s-3) 대응은 나무위키에 기록되어 있을 만큼 악명높은 모양이다.

수많은 개발자들이 티스토리에 기술 블로그를 올리고 있는 만큼 현실적으로는 가능성이 낮은 일이겠지만, 만의 하나라도 내 블로그 전체가 한 순간에 날아가고 복구할 수도 없게 될 수 있다는 것은 매우 큰 감점요인이다.  

심지어 티스토리는 자체 백업 기능도 없다. 외부 툴은 있지만 완벽하다고는 하기 어렵다.
<br><br>

### 벨로그를 선택하지 않은 이유
그 다음으로 고려했던 벨로그도 같은 이유로 탈락.

벨로그는 velopert라는 개발자 한 명이 만든 블로그 플랫폼이고, 이는 언제든 개인 사정으로 서비스가 중단될 가능성이 있다는 뜻이다.

게다가 벨로그는 티스토리같은 위지윅(WYSIWYG) 에디터가 아니라 마크다운(Markdown) 문법을 사용한다.

그럼 깃허브 블로그랑 사실상 차이도 없지 않나?
<br><br>

### 최종 선택

그래서 최종적으로 고르게 된 것이 깃허브 블로그였다.

이쪽을 고르게 된 이유는 다음과 같다.

- 개념은 그다지 어렵지 않다. Git에 대한 기본개념과 약간의 프로그래밍 지식만 있으면 블로그를 만들 수 있다. ***<span style="color:red">아마도</span>***.  
  * 물론 여기서 어렵지 않다는 어디까지나 개발자 기준이다. 깃허브 블로그를 고려하는 사람이 Git에 대한 기본적 이해가 없다는 건 애초에 말이 안 되니까.
  * 마찬가지로 마크다운과 HTML도 통상적인 개발자에게는 어려운 개념이 아니다. 내가 아무리 IT 원시인이 됐다지만 이건 수십 년 전부터 있었던 개념이잖아?
- 블로그 원본이 로컬에 저장된다. 설령 깃허브 사이트가 사라지더라도 내가 원본을 보존하고 있는 이상 글은 보존되며, 사이트도 아주 쉽게 복구할 수 있다.
- 요즘 개발블로그의 대세처럼 보인다.  
  애초에 최신 개발 트렌드를 공부하고 따라잡으려고 시작한 일인 만큼, 기왕 할 거면 가장 최신의 트렌드에 맞춰야하지 않을까?

그런 고민 끝에 최종적으로 깃허브를 고르게 되었다.

<br>

## Github 블로그 사용감상
*****
<span style="color:#999955">***불편하고 공부할 게 많다***.<span>

> 시밤 이 불편한 짓을 전 세계 수백만의 개발자들이 하고 있다고? 이게 요즘 인싸 프로그래머들의 트렌드라고? 제정신들인가?

깃허브 블로그를 세팅하는 내내 든 생각이었다.

### 일단 설치
그다지 어렵지 않을 거라는 내 예상은 반만 맞고 반은 틀렸다.  
아니 정확히는 30%쯤 맞고 70%쯤 틀렸다고 해야 할까.

처음에 나는 이 글을 보고 깃허브 블로그를 별도의 로컬 작업 없이 깃허브 서비스만으로 세팅할 수 있다고 생각했다.

https://ahnslab.com/21-how-to-start-github-blog/  
```
Github 블로그 시작하는 방법(로컬 설치 없이 쉽게 만들기)
```
깃허브 블로그가 돌아가는 구조와 개념, jekyll 등에 대해서는 별도의 포스트로 작성할 예정이지만, 결론만 말하자면 이 글의 내용은 맞다고도 틀리다고도 할 수 있다.

깃허브는 자체적으로 jekyll 빌드를 지원하므로, 이론상으로는 로컬에서 뭔가 설치할 필요 없이 블로그를 만들 수 있다.

***하지만, 상당수의 깃허브 블로그 스킨(테마)는 그렇지 않다.***

깃허브 블로그 테마는 일종의 코드로 짜여진 프로젝트이고, 당연히 테마마다 개발환경이나 설정이 조금씩 다르다.  
깃허브가 jekyll을 자체지원하기 전부터 개발되어 왔거나, 그냥 로컬에서 빌드하는 걸 전제로 설게된 테마들은 설정 자체를 일단 로컬에서 해야 올릴 수 있도록 되어 있는 것들이 있다.

그리고 운 나쁘게, 내가 선택한 이 블로그 테마인 [Chirpy](http://jekyllthemes.org/themes/jekyll-theme-chirpy/)도 그런 케이스였다.

이 블로그 테마는 일단 로컬에서 한 번 빌드를 해서 Gemfile을 생성한 후에 깃허브에 올려야 정상 동작한다. 적어도 설치 매뉴얼에 따르면 그렇다.  
이 과정을 패스하는 방법이 있을지도 모르지만 난 그 방법을 찾을 만큼 Ruby나 Jekyll을 잘 알지 못한다.

> 그러니까, 고작 블로그 하나 만들려고 다른 용도로는 쓸 일도 없는 Ruby랑 jekyll 개발환경을 깔고 빌드 세팅을 하라고?

내가 생각했던 깃허브 블로그의 개설 난이도는 딱 저 위에 링크한, 로컬 설치 없이 만드는 수준이었다. 이건 예상범위 밖이다. 제네바 협정 위반이다.

> 그럼 테마를 바꾸면 되지 않나? 

그런 생각으로 쭉 찾아봤지만, 로컬 빌드가 필요없다고 확신할 수 있는 테마 중에는 마음에 드는 게 없었다.

> 그럼 테마를 그냥 내가 커스터마이징하면?  

나는 CSS나 Ruby 전문가가 아니다. 이쪽은 정말 기본 개념밖에 모른다.  
물론 그걸로도 어찌어찌 할 수는 있겠지만, 그 과정에서 얼마나 많은 시행착오를 거치고 시간을 얼마나 쓸지 상상하는 것만으로도 대략 정신이 멍해진다.

그렇게 몇 시간을 고민한 끝에, 결국 나는 뇌를 비우고 무지성 따라가기를 선택했고, 테마에서 시키는 대로 루비랑 자칼을 깔고...   

블로그 하나 개설하기 위해 거의 1박 2일을 씨름해야 했다.
<br><br>

### 포스팅
개설부터가 이 난리였지만, 포스팅도 생각 이상으로 불편하다.

마크다운 문법이 익숙해지면 크게 불편하진 않지만, 그와 별개로 문제가 한둘이 아니다.

일단 위지윅 지원이 없다.

즉, 내가 쓰고 있는 글이 실제 블로그에서 어떻게 보일지 미리보기가 실시간으로 되지 않는다.  
마크다운 문법 자체는 미리보기가 되지만, 그게 블로그 내에서 어떻게 보일지는 또 다른 문제니까.

내가 구글링해서 찾아낸 이 문제의 해결법은, 로컬에서 jekyll 서버를 띄워서 그걸로 미리보기를 하는 것이다.  

https://ansohxxn.github.io/blog/posting/#6-%EB%A7%88%ED%81%AC%EB%8B%A4%EC%9A%B4%EC%9C%BC%EB%A1%9C-%EC%93%B4-%ED%8F%AC%EC%8A%A4%ED%8A%B8-%EB%82%B4%EC%9A%A9%EC%9D%84-%EB%AF%B8%EB%A6%AC-%EB%B3%B4%EA%B8%B0
```
[Github 블로그] 블로그 포스팅하는 방법
```
딱 봐도 편리함과는 거리가 멀어 보이지 않는가?  

그리고 포스트에 이미지를 추가하는 것도 불편하다.  
그냥 버튼 한 번 누르고 사진 드래그하면 이미지가 포스팅에 추가되는 기존 서비스형 블로그를 생각하면 안 된다.

깃허브 블로그에 이미지를 추가하려면 해당 이미지를 어디엔가 업로드한 후, 링크를 따와서 직접 링크 주소를 붙여넣어야 한다.  
기술 블로그야 이미지를 그리 많이 안 쓰니까 감수할 수 있겠지만, 짤이나 이미지를 많이 올리는 사람이라면 상당히 불편할 것이다.

그 외에도 사소한 불편함은 많고, 글을 쓰는 지금도 실시간으로 늘어나고 있다.
<br><br>

### 그래서 해법은?
해법은 반드시 존재한다. 어딘가에.

프로그래머라는 인종은 근본적으로 불편을 견디며 사는 자들이 아니다.  
노가다? 자동화해야지! 손이 많이 가? 매크로나 스크립트로 해결하면 되지!   
그게 프로그래머의 기본 마인드다.  
깃허브 블로그를 수백만 명의 개발자들이 쓰고 있는 이상, 이 불편함의 대부분을 해결하거나 자동화하는 방법은 어딘가에는 있을 것이다.

문제는 그 방법을 다 찾아서 익히고, 모든 코딩이 다 그렇듯 일단 자기 개발환경에 맞춰 세팅해야 한다는 것이다.

즉, 깃허브 블로그를 편하게 쓰려면, 그러기 위한 환경을 자기 스타일이나 환경에 맞춰서 세팅하는 과정이 필요하다. 
<br><br>

## 결론
***

블로그 개설 자체는 크게 어렵지는 않다. 그냥 기본적인 개념만 알고, 개설 방법이 잘 나와 있는 튜토리얼을 찾아 따라하면 된다.  

깃허브 블로그가 가장 어려운 부분은 설치 자체가 아니라, 설치 후에 자기가 편리하게 쓰기 위한 환경을 세팅하는 과정이다. 이 부분만은 개발자 개개인마다 환경이나 취향이 다르기 때문에 그냥 남의 것을 가져다 쓰기도 어렵다.

이게 내가 2박 3일동안 블로그 하나 개설하겠다고 온갖 삽질을 하면서 내린 결론이다.

앞으로 계속 블로그를 세팅하면서 관련 정보나 내 세팅 방법을 포스팅할 생각이다.  
다만 이걸 남에게 추천할 수 있느냐 하면, 솔직히 티스토리나 벨로그를 추천하는 게 무난하고 욕 안 먹는 방법이 아닐까.








