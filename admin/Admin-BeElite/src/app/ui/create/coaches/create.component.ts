import { Component } from '@angular/core';
import { FormGroup, FormControl, Validators, AbstractControl } from '@angular/forms';
import { customEmailValidator, matchpassword, usernameValidator } from '../../../misc/validators';
import { PostService } from '../../../service/post/post.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';

@Component({
  selector: 'app-create-coach',
  standalone: false,
  templateUrl: './create.component.html',
  styleUrl: './create.component.css'
})
export class CreateCoachComponent {

  form!: FormGroup;
  profilePic!: File;
  submitted = false;

  constructor(public postService: PostService, private toastr: ToastrService, private router: Router) { }

  ngOnInit(): void {
    this.form = new FormGroup({
      name: new FormControl('', [Validators.required]),
      username: new FormControl('', [Validators.required], [usernameValidator(this.postService)]),
      email: new FormControl('', [Validators.required, customEmailValidator.bind(this)]),
      password: new FormControl('', [Validators.required, Validators.minLength(6)]),
      verifyPassword: new FormControl('', Validators.required),
    }, { validators: matchpassword });
  }

  get f() {
    return this.form.controls;
  }

  submit() {
    this.submitted = true;
    if (this.form.valid) {
      this.postService.createCoach(this.form.value).subscribe({
        next: resp => {
          if(resp){
            this.toastr.success("New coach has been created successfully.", "Success!")
            this.router.navigate(["/admin/coaches"]);
          }
        }, error: err => {
          this.toastr.error("There has been an error creating the coach.")
        }
      })
    }
  }
}

