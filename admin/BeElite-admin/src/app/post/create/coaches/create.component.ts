import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PostService } from '../../service/post/post.service';
import { Router } from '@angular/router';
import { ReactiveFormsModule, FormGroup, FormControl, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { usernameValidator } from '../../../misc/username.validator';
import { Observable, map, of, switchMap, timer } from 'rxjs';

@Component({
  selector: 'app-create-coach',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './create.component.html',
  styleUrl: './create.component.css'
})
export class CreateCoachComponent {

  form!: FormGroup;
  profilePic!: File;
  submitted = false;

  constructor(public postService: PostService, private router: Router) { }

  customEmailValidator(control: AbstractControl) {
    const pattern = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,20}$/;
    const value = control.value;
    if (!pattern.test(value))
      return {
        invalidAddress: true
      }
    else return null;
  }

  usernameValidator({ value }: AbstractControl): Observable<ValidationErrors> {
    return timer(200).pipe(
      switchMap(() => {
        if (!value) {
          return of(null);
        }
        return this.postService.checkUsername(value).pipe(
          map(isValid => {
            if (!isValid) {
              return {
                isNotValid: true
              };
            }
            return null;
          })
        );
      })
    );
  };
  }

ngOnInit(): void {
  this.form = new FormGroup({
    name: new FormControl('', [Validators.required]),
    username: new FormControl('', [Validators.required, this.usernameValidator]),
    email: new FormControl('', [Validators.required, this.customEmailValidator.bind(this)]),
    password: new FormControl('', Validators.required),
    verifyPassword: new FormControl('', Validators.required),
  });
}

  get f() {
  return this.form.controls;
}

submit() {
  this.submitted = true;
  if(this.form.valid){
    this.postService.createCoach(this.form.value).subscribe({
      next: resp => {
  
      }, error: err => {
      }
    })
  }
}

}
