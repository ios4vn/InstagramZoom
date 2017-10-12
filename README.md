# InstagramZoom
Easily add zoom functionality similar to Instagram

<img src="preview.gif" width="226" height="402" />

## Getting Started

Swift version of TMImageZoom https://github.com/twomedia/TMImageZoom

Demo will be update later

### Installing

Start by adding a UIPinchGestureRecognizer to the view you would like to receive touches and create a pinch: method
```
let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.imagePinched(_:)))
pinchGesture.delegate = self
self.view.addGestureRecognizer(pinchGesture)

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    
}
```

Then inside the pinch: method, use the shared instance of TMImageZoom and call the gestureStateChanged: method. We will pass the gesture as well as the UIImageView we would like to zoom.
```
@objc private func imagePinched(_ pinch: UIPinchGestureRecognizer) {
    InstaZoom.shared.gestureStateChanged(gesture: pinch, zoomImageView: previewImage)
}
```


## Authors

* **Hai Trieu** - https://github.com/ios4vn

## License

> Copyright (c) 2009-2017: Hai Trieu
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
> LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
> OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
> WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
