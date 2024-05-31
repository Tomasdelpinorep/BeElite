import { Component, HostBinding, OnInit, inject } from '@angular/core';
import { Router } from '@angular/router';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { TokenStorageService } from '../../service/auth/token.storage.service';
import { AuthService } from '../../service/auth/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent implements OnInit{
  @HostBinding('class.vw-100') applyClass = true;
  form!: FormGroup;
  isLoggedIn = false;
  isLoginFailed = false;
  errorMessage = '';
  role: String = "";
  username!: string;
  router = inject(Router);

  constructor(private authService: AuthService, private tokenStorage: TokenStorageService ) {}

  ngOnInit(): void {
    this.form = new FormGroup({
      username: new FormControl('', [Validators.required]),
      password: new FormControl('', Validators.required)    });
  }

  login(): void {
    this.authService.login(this.form.value.username, this.form.value.password).subscribe({
      next: data => {
        //this.tokenStorage.saveToken(data.accessToken);
        this.tokenStorage.saveToken(data.token);
        this.tokenStorage.saveUser(data);
        localStorage.setItem("USER_ID", data.id)

        this.isLoginFailed = false;
        this.isLoggedIn = true;
        this.role = data.role;
        this.username = data.username;
        this.router.navigate(['/admin/coaches']);
      },
      error: err => {
        this.errorMessage = err.error.message;
        this.isLoginFailed = true;
        console.log(err);
      }
    });
  }

  get f(){
    return this.form.controls;
  }
}