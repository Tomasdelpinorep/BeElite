import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PostService } from '../../service/post/post.service';
import { Router } from '@angular/router';
import { ReactiveFormsModule, FormGroup, FormControl, Validators, AbstractControl } from '@angular/forms';
import { UserDto } from '../../../models/user-dto.intercace';

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

  /*------------------------------------------
  --------------------------------------------
  Created constructor
  --------------------------------------------
  --------------------------------------------*/
  constructor(public postService: PostService,private router: Router) { }

  customeEmailValidator(control:AbstractControl) {
    const pattern = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,20}$/;
    const value = control.value;
    if(!pattern.test(value)) 
      return {
        invalidAddress:true
      }
    else return null;
}

  ngOnInit(): void {
    this.form = new FormGroup({
      name: new FormControl('', [Validators.required]),
      username: new FormControl('', Validators.required),
      email: new FormControl('', [Validators.required, this.customeEmailValidator]),
      password: new FormControl('', Validators.required),
      verifyPassword: new FormControl('', Validators.required),
    });
  }

  get f() {
    return this.form.controls;
  }

  submit() {
    this.submitted = true;
    this.postService.createCoach(this.form.value).subscribe({
      next: resp => {

      }, error: err => {

      }
    })
  }

  onFileSelected(event:any){
    this.profilePic=event.target.files[0];
  }

}