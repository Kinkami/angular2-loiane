import { Usuario } from './usuario';
import { AuthService } from './auth.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private authService: AuthService) { }
private usuario: Usuario = new Usuario();

  ngOnInit() {
  }

  fazerLogin(){
//console.log(this.usuario);
this.authService.fazerLogin(this.usuario);
  }

}
