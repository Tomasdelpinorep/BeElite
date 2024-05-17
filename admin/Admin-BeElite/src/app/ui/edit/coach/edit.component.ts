import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { CoachDetails } from '../../../models/coach-details-dto.interface';
import { PostService } from '../../../service/post/post.service';
  
@Component({
  selector: 'app-edit',
  standalone: false,
  templateUrl: './edit.component.html',
  styleUrl: './edit.component.css'
})
export class EditComponent {
  
  coachUsername!: String;
  coachDetails!: CoachDetails;
      
  constructor(
    public postService: PostService,
    private route: ActivatedRoute,
    private router: Router
  ) { }
      
  form : FormGroup = new FormGroup({
    name: new FormControl('', [Validators.required]),
    username: new FormControl('', Validators.required),
    email: new FormControl('', Validators.required)
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
      
  submit(){
    console.log(this.form.value);
    this.postService.editCoach(this.coachUsername, this.form.value).subscribe((res:any) => {
         console.log('Coach updated successfully!');
         this.router.navigateByUrl('post/index');
    })
  }
  
}