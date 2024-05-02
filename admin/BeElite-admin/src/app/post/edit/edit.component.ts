import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PostService } from '../service/post/post.service';
import { ActivatedRoute, Router } from '@angular/router';
import { ReactiveFormsModule, FormGroup, FormControl, Validators } from '@angular/forms';
import { CoachDetails } from '../../models/coach-details-dto.interface';
  
@Component({
  selector: 'app-edit',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './edit.component.html',
  styleUrl: './edit.component.css'
})
export class EditComponent {
  
  coachUsername!: String;
  coachDetails!: CoachDetails;
  form!: FormGroup;
      
  /*------------------------------------------
  --------------------------------------------
  Created constructor
  --------------------------------------------
  --------------------------------------------*/
  constructor(
    public postService: PostService,
    private route: ActivatedRoute,
    private router: Router
  ) { }
      
  /**
   * Write code on Method
   *
   * @return response()
   */
  ngOnInit(): void {
    this.coachUsername = this.route.snapshot.params['coachUsername'];
    this.postService.findCoach(this.coachUsername).subscribe((data: CoachDetails)=>{
      this.coachDetails = data;
    }); 
        
    this.form = new FormGroup({
      username: new FormControl('', [Validators.required]),
      name: new FormControl('', Validators.required),
      email: new FormControl('', Validators.required),
      profilePicUrl: new FormControl('', Validators.required)
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