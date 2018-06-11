import { Directive, ElementRef, Renderer } from '@angular/core';

@Directive({
  selector: '[fundoAmarelo]'
})
export class FundoAmareloDirective {

  constructor(private _elementRef: ElementRef,
    private _renderer: Renderer) {
    //  this._elementRef.nativeElement.style.backgroundColor = 'yellow'; +++++ NOT SAFE
    this._renderer.setElementStyle(this._elementRef.nativeElement, 'background-color', 'yellow');
  }

}
