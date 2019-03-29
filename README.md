# Swift Study Jam#0 


## 題目：

Webservice-下載圖片的處理

### 畫面包括以下元件：
imageView * 1
textField * 1
Button * 2 (show & clear)

像這樣：
![](https://i.imgur.com/RaG7uEM.png)



### 流程：
1. 畫面一進入，imageView會顯示 default圖片
2. 在textField 貼上圖片網址按 Show Button 會下載圖片
3. 結束下載後顯示在 image View 上並在 console print “Downloaded”
4. 貼上一樣的 URL 不會進行下載
5. 貼上不一樣的 URL 才會進行下載
6. 按 clear button 會清除圖片並顯示 default圖片

### 限制：
1.  要用非同步下載


## 範例
https://youtu.be/hlOh-oio-24



## StarterProject: 

###  master branch

https://github.com/lumanmann/HandlingImageDownload

包括寫好的元件和一張default圖片
有需要請拿來使用～～

## 如果你不想找圖片，請用：
https://cdn.pixabay.com/photo/2017/06/05/20/10/blue-2375119_1280.jpg
https://cdn.pixabay.com/photo/2015/09/27/20/12/women-961208_1280.jpg

## 關於題目
這次的題目是Webservice-下載圖片的異步處理，靈感來自 Kingfisher這套套件。
Kingfisher 會幫忙從網址下載圖片顯示，同時暫存於記憶體快取及硬碟快取之中，當這張圖需要在此顯示時就會從快取中取出而不會重新下載。



