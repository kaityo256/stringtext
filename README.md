# 分子動力学法で一瞬文字が浮かび上がるアニメーションを作る

## 概要

分子動力学法で粒子を動かして文字が一瞬浮かび上がるアニメーションを作ります。分子動力学法といっても粒子間の相互作用は考えません。

## 使い方

### Ballistic版

全ての粒子が等速直線運動をするバージョンです。

```sh
ruby st_b.rb
```

これで `img000.png`から`img199.png`ができるので、ImageMagickでなんかします。

```sh
mogrify -resize 50% *.png
convert -delay 10 -loop 0 img*.png b.gif
```

こんなGIFができます。

![b.gif](gif/b.gif)

### Diffusion版

全ての粒子がブラウン運動をするバージョンです。

```sh
ruby st_d.rb
```

これで `img000.png`から`img199.png`ができるので、やっぱりImageMagickでなんかします。

```sh
mogrify -resize 50% *.png
convert -delay 10 -loop 0 img*.png b.gif
```

こんなGIFができます。

![d.gif](gif/d.gif)

## ライセンス

MIT
