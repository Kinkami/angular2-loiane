import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms/src/model';
import { FormBuilder, Validators } from '@angular/forms';
import { Http } from '@angular/http';


@Component({
  selector: 'app-data-form',
  templateUrl: './data-form.component.html',
  styleUrls: ['./data-form.component.css']
})
export class DataFormComponent implements OnInit {

  formulario: FormGroup;
  constructor(
    private http: Http,
    private formBulider: FormBuilder) { }

  ngOnInit() {
    // this.formulario = new FormGroup(
    //   {
    //     nome: new FormControl(null),
    //     email: new FormControl(null)
    //   }
    // );
    this.formulario = this.formBulider.group({
      nome: [null, [Validators.required]],
      email: [null, [Validators.required, Validators.email]]
    })
  }

  onSubmit() {
    console.log(this.formulario.value);
    this.http.post('https://httpbin.org/post', JSON.stringify(this.formulario.value)).map(res => res).subscribe(
      dados => {
        console.log(dados);
        //   this.resetar();
      },
      (error: any) => alert('erro'));
  }

  resetar() {
    this.formulario.reset();
  }

  verificaValidTouched(campo: string) {
    return !this.formulario.get(campo).valid && this.formulario.get(campo).touched;

  }
  aplicaCssErro(campo: string) {
    return {
      'has-error': this.verificaValidTouched(campo),
      'has-feedback': this.verificaValidTouched(campo)
    }
  }

  verificaEmailInvalido() {
    let campoEmail = this.formulario.get('email');
    if (campoEmail.errors) {
      return campoEmail.errors['email'] && campoEmail.touched;
    }
  }
}
