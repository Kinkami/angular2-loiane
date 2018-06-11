import { Http } from '@angular/http';
import { Component, OnInit, } from '@angular/core';
import 'rxjs/add/operator/map';


@Component({
  selector: 'app-template-form',
  templateUrl: './template-form.component.html',
  styleUrls: ['./template-form.component.css']
})
export class TemplateFormComponent implements OnInit {

  usuario: any = {
    nome: null, //'Fer',
    email: null//'fer@email.com'
  }

  constructor(private http: Http) { }

  ngOnInit() {
  }

  onSubmit(form) {
    // console.log(form);
    this.http.post('https://httpbin.org/post', JSON.stringify(form.value)).map(res => res).subscribe(
      dados => {
        console.log(dados);
        form.form.reset();
      });
  }

  verificaValidTouched(campo) {
    return !campo.valid && campo.touchedl
  }

  aplicaCSSErro(campo) {
    return {
      'has-error': this.verificaValidTouched(campo),
      'has-feedback': this.verificaValidTouched(campo)
    }
  }

  consultaCEP(cep, form) {
    cep = cep.replace(/\D/g, '');
    if (cep != "") {
      var validacep = /^[0-9]{8}$/;
      this.resetaDadosForm(form);
      if (validacep.test(cep)) {
        this.http.get(`//viacep.com.br/ws/${cep}/json/`).map(dados => dados.json()).subscribe(dados => this.populaDadosFOrm(dados, form));
      }
    }
  }
  populaDadosFOrm(dados, formulario) {
    formulario.form.patchValue({
      rua: dados.logradouro,
      complemento: dados.complemento,
      bairro: dados.bairro,
      cidade: dados.localidade,
      estado: dados.uf
    });
  }

  resetaDadosForm(formulario) {
    formulario.form.patchValue({
      rua: null,
      complemento: null,
      bairro: null,
      cidade: null,
      estado: null
    });
  }

}
