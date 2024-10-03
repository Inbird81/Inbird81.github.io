---
title:  "Skp 파일의 구조 읽어들이기"

categories:
  - Sketchup SDK
tags:
  - [Sketchup SDK]

img_path: /images/
toc: false
toc_sticky: false

date: 2008-11-6
---
_* 이전 블로그 백업글 : 이 게시물은 2008~2013년 사이에 작성된 것으로, 2024년 현재의 환경과는 맞지 않을 수 있습니다._

### Materials
>Skp 파일 내에서 사용되는 전체 메테리얼의 리스트를 도큐먼트 클래스의 `GetMaterials()` 함수로 얻을 수 있다. 각각의 메테리얼은 위의 함수로 얻어진 `ISkpMaterials`객체에서 `GetItem()`함수로 얻는다.<br>
>각각의 컴포넌트, 그룹, 이미지, 면(Face)는 자신이 사용하는 메테리얼의 정보를 가지고 있다. 하나의 메테리얼이 여러 곳에서 사용될 수 있으므로, 전체 메테리얼 리스트를 나열한 후 각 객체들은 자신이 사용하는 메테리얼의 ID만을 참고하면 된다. 특히 면의 경우 앞면과 뒷면에 각각 메테리얼을 가질 수 있다. 

### OptionManager
>옵션 매니저 클래스는 도큐먼트에서 `GetOptionManager()` 함수로 얻는다. 얻어진 옵션 매니저 클래스의 `GetItem()`함수로 `OptionProvider` 클래스를 얻을 수 있는데, 이 클래스는 각각의 옵션을 나타낸다. 하나의 옵션 내에는 여러 개의 설정값이 들어갈 수 있으며, 각각의 설정값은 역시 `OptionProvider`의 `GetItem()`함수로 얻는다.<br>
>옵션에는 스케치업에서 지원하는 안개(fog)나 그림자, 랜더링 옵션, 각종 단위 같은 잡다한 설정값들이 들어간다.

### Layers
>도큐먼트 클래스의 `GetLayers()` 함수로 전체 레이어 리스트를 얻어올 수 있다. 얻어진 레이어 리스트에서는 GetItem()으로 각각의 레이어를 얻는다.<br>
>컴포넌트, 그룹, 이미지, 면, 외각선(Edge)등 모든 객체는 자신이 속한 레이어의 정보를 가지고 있다. 전체 레이어를 나열한 후, 각각의 객체가 속한 레이어를 ID로 참조하는 것이 좋다.<br>
>대부분의 객체는 자신이 속한 레이어의 정보를 직접 가져올 수 없으며, `ISkpDrawingElement` 클래스로 변환해야만 `GetLayer()`함수를 쓸 수 있다. `ISkpDrawingElement`는 거의 모든 객체와 연결되는 인터페이스이다.

### ComponentDefinitions
>스케치업에는 객체들을 묶을 수 있는 방법으로 컴포넌트와 그룹 두 가지를 지원하는데, 둘의 가장 큰 특징은 인스턴싱(Instancing)이다. 이 클래스는 인스턴스가 아닌 컴포넌트의 원본 데이터를 저장한다. Skp 파일 내에서 사용되는 모든 컴포넌트 정의의 리스트는 도큐먼트 클래스의 `GetComponentDefinitions()`함수로 얻을 수 있다. 모든 컴포넌트 정의를 나열하고, 컴포넌트 인스턴스가 정의를 참조하도록 하면 처리속도와 공간을 절약할 수 있다.<br>
>단, 도큐먼트에서 컴포넌트 정의 리스트를 직접 불러오는 것은 비추. 이유는 다음에 설명하겠다.

### ComponentInstance
>컴포넌트 인스턴스는 컴포넌트 정의(ComponentDefinition 객체)를 인스턴싱한 객체이다. 내부적으로 변환(Transform) 정보와 자신의 컴포넌트 정의 객체에 대한 참조를 가지고 있다.<br>
>컴포넌트 인스턴스를 추출하는 방법은 Group와 같이 설명해야 한다.<br>
>참고로 스케치업에서는 컴포넌트 인스턴스와 정의 각각에 이름을 줄 수 있다.

### Group
>Document, Group, ComponentDefinition, Image 객체는 모두 `ISkpEntityProvider` 인터페이스에서 참조할 수 있다. 그리고 그룹이나 컴포넌트는 다중으로 묶일 수 있으므로, 전체 그룹이나 인스턴스의 목록을 얻기 위해서는 도큐먼트로부터 재귀적으로 검색해야 한다.<br>
>예를 들어 오브젝트가 컴포넌트로 묶인 후 그룹으로 묶이고, 그 그룹이 또 컴포넌트로 묶여 있다면 오브젝트를 호출하기 위해서는 도큐먼트->컴포넌트->그룹->컴포넌트->오브젝트 순으로 호출해야 한다.<br>
>재귀호출을 이용해서 계층구조를 포함한 그룹/컴포넌트의 전체 리스트 및 구조를 뽑아내는 방법은 다음과 같다.

```c++
void ReadGeometryMain(ISkpEntityProviderPtr pEntProvider, FILE* fp)
{
  HRESULT hr;
  long nElements;

  //Recurse all the instances
  ISkpComponentInstancesPtr pInstances = NULL;

  hr = pEntProvider->get_ComponentInstances(&pInstances);
  hr = pInstances->get_Count(&nElements);

  for(long i=0; i<nElements; i++)
  {
    ISkpComponentInstancePtr pInstance = pInstances->Item[i];

    AddComponentDefinition(pInstance->ComponentDefinition);

    BSTR name = pInstance->GetName();

    fprintf(fp, "<ComponentInstance id=%ld name=%s defId=%ld>\n",
    GetID(pInstance), (char*)_bstr_t(name, true), GetID(pInstance->GetComponentDefinition()));
    ReadTransform(pInstance->Transform, fp);
    fprintf(fp, "</ComponentInstance>\n");
  }

  //Recurse all the groups
  ISkpGroupsPtr pGroups = NULL;

  hr = pEntProvider->get_Groups(&pGroups);
  hr = pGroups->get_Count(&nElements);

  for(long i=0; i<nElements; i++)
  {
    ISkpGroupPtr pGroup = pGroups->Item[i];

    ISkpEntityPtr IEnt = pGroup;
    long entityId = IEnt->Id;
    BSTR name;
    pGroup->get_Name(&name);

    fprintf(fp, "<Group id=%ld name=%s>\n", entityId, (char*)_bstr_t(name, true));
    ReadTransform(pGroup->Transform, fp);
    ReadGeometryMain(pGroup, fp);
    fprintf(fp, "</Group>\n");
  }

  //Recurse all the images
  ISkpImagesPtr pImages = NULL;

  hr = pEntProvider->get_Images(&pImages);
  hr = pImages->get_Count(&nElements);

  for(long i=0; i<nElements; i++)
  {
    ISkpImagePtr pImage = pImages->Item[i];

    ISkpEntityPtr IEnt = pImage;
    long entityId = IEnt->Id;
    BSTR name;
    pImage->get_Name(&name);

    fprintf(fp, "<Image id=%ld name=%s>\n", entityId, (char*)_bstr_t(name, true));
    ReadTransform(pImage->Transform, fp);
    ReadGeometryMain(pImage, fp);
    fprintf(fp, "</Image>\n");
  }

  //Write all the faces
  ISkpFacesPtr pFaces = NULL;
  hr = pEntProvider->get_Faces(&pFaces);
  hr = pFaces->get_Count(&nElements);

  if(nElements > 0)
  {
    fprintf(fp, "<Faces count=%ld>\n", nElements);
    for(long i=0; i<nElements; i++)
    {
      ISkpFacePtr pFace;
      hr = pFaces->get_Item(i, &pFace);

      if (hr==S_OK)
      ReadFace(pFace, fp);
    }
    fprintf(fp, "</Faces>\n");
  }

  //Write all the edges
  ISkpEdgesPtr pEdges = NULL;
  hr = pEntProvider->get_Edges(&pEdges);
  hr = pEdges->get_Count(&nElements);

  if(nElements > 0)
  {
    fprintf(fp, "<Edges count=%ld>\n", nElements);
    for(long i=0; i<nElements; i++)
    {
      ISkpEdgePtr pEdge;
      hr = pEdges->get_Item(i, &pEdge);

      if (hr==S_OK)
      ReadEdge(pEdge, fp);
    }
    fprintf(fp, "</Edges>\n");
  }
}
```
>`ISkpEntityProvider`가 그룹, 컴포넌트, 이미지 전부를 참조할 수 있음에 유의.
>이 함수는 `Face`나 `Edge`가 나올 때까지 재귀호출을 반복하면서 계층구조를 표시한다. 단 컴포넌트 인스턴스는 정의를 참조할 뿐이므로 재귀호출하지 않는다.

### Image
>이미지 객체라고 하는데, 사실 왜 그룹/컴포넌트와 같이 계층구조를 이루는 건지 모르겠다. 벡터 이미지라면 선이나 면의 집합일 수도 있는데, API 레퍼런스에 당당하게 **‘An Image object represents a raster image placed in the Model’**이라고 쓰여 있으니 그런 것 같지도 않고…<br>
>일단 위의 `ReadGeometryMain()` 함수는 샘플 코드를 참조한 거라 그쪽에 있는 그대로 썼다.

### Transform
>변환 행렬. 4x4 행렬이다. 인스턴스나 그룹, 이미지 클래스에서 GetTransForm() 함수로 얻을 수 있다.<br>
>skp 파일을 읽어들이는 방법은 대강..<br>
```c++
SketchUp::ISkpApplicationPtr pApp = CSkpModelFactory::GetSkpApplication();
if(pApp == NULL) return -1;
SketchUp::ISkpFileReaderPtr pFileReader = pApp;
SketchUp::ISkpDocumentPtr pDoc = pFileReader->OpenFile("test.skp");
```
>이 다음에 메테리얼, 레이어, 옵션의 리스트를 읽은 후 컴포넌트/객체 정보를 검색해서 뽑아내면 된다.

Face, Edge, Mesh는…나도 샘플 코드 그대로 가져다 쓴 것 뿐이라 딱히 정리할만한 지식이 없음.

스케치업에 있는 데이터가 이것뿐일 리는 없지만, 일단은 이 정도.