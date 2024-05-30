import { Component, HostBinding } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { customEmailValidator, matchpassword, usernameValidator } from '../../../misc/validators';
import { PostService } from '../../../service/post/post.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';

@Component({
  selector: 'app-create-coach',
  standalone: false,
  templateUrl: './create-program.component.html',
  styleUrl: './create-program.component.scss'
})
export class CreateProgramComponent {
  @HostBinding('class.w-100') applyClass = true;
  form!: FormGroup;
  profilePic!: File;
  submitted = false;
  coachMap!: { [key: string]: string };
  coachNameList!: string[];
  selectedProgramPic!: any;

  constructor(public postService: PostService, private toastr: ToastrService, private router: Router) { }
  ngOnInit(): void {
    this.postService.getAllCoachNamesAndId().subscribe({
      next: resp => { 
        this.coachMap = resp;
        this.coachNameList = Object.keys(resp);
      }, error: err => {
        this.toastr.error("There was an error getting the available coaches.")
      }
    })

    this.form = new FormGroup({
      programName: new FormControl('', [Validators.required]),
      programDescription: new FormControl('', [Validators.required], [usernameValidator(this.postService)]),
      programCoach: new FormControl('', [Validators.required]),
    });
  }

  get f() {
    return this.form.controls;
  }

  submit() {
    this.submitted = true;
    if (this.form.valid) {
      this.postService.createProgram(this.form.value, this.selectedProgramPic).subscribe({
        next: resp => {
          if(resp){
            this.toastr.success("New program has been created successfully.", "Success!")
            this.router.navigate(["/admin/programs"]);
          }
        }, error: err => {
          this.toastr.error("There has been an error creating the program.")
        }
      })
    }
  }

  onFileSelected(event: any) {
    this.selectedProgramPic = event.target.files[0];
  }
}

