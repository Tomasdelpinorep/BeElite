import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { CoachDetails } from '../../../models/coach-details-dto.interface';
import { PostService } from '../../../service/post/post.service';
import { ToastrService } from 'ngx-toastr';
import { environment } from '../../../environment/environtments';
import { customEmailValidator } from '../../../misc/validators';
  
@Component({
  selector: 'app-edit',
  standalone: false,
  templateUrl: './edit.component.html',
  styleUrl: './edit.component.css'
})
export class EditComponent {
  
  coachUsername!: String;
  coachDetails!: CoachDetails;
  defaultProgramPicUrl: String = environment.defaultProfilePicUrl;
      
  constructor(
    public postService: PostService,
    private route: ActivatedRoute,
    private router: Router,
    private toastr: ToastrService
  ) { }
      
  form : FormGroup = new FormGroup({
    name: new FormControl('', [Validators.required]),
    username: new FormControl('', Validators.required),
    email: new FormControl('', [Validators.required, customEmailValidator])
  });

  ngOnInit(): void {
    this.coachUsername = this.route.snapshot.params['coachUsername'];
    this.postService.findCoach(this.coachUsername).subscribe((data: CoachDetails)=>{
      this.coachDetails = data;

      this.form.patchValue({
        name: data.name,
        username: data.username,
        email: data.email
      });
    }); 
  }

  get f(){
    return this.form.controls;
  }
      
  submit() {
    if (this.form.valid) {
      this.postService.editCoach(this.form.value, this.coachUsername).subscribe({
        next: resp => {
          if(resp){
            this.toastr.success("Coach has been updated successfully.", "Success!")
            this.router.navigate(["/admin/coaches"]);
          }
        }, error: err => {
          this.toastr.error("There has been an error updating the coach.")
        }
      })
    }
  }
  
}