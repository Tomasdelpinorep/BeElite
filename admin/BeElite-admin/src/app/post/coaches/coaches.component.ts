import { Component } from '@angular/core';
  
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { PostService } from '../service/post/post.service';
import { UserDto } from '../../models/user-dto.intercace';
import { NavbarComponent } from "../../components/navbar/navbar.component";
  
@Component({
    selector: 'app-coaches',
    standalone: true,
    templateUrl: './coaches.component.html',
    styleUrl: './coaches.component.css',
    imports: [CommonModule, RouterModule, NavbarComponent]
})
export class AdminCoachesComponent {
  
  coachList: UserDto[] = [];
  currentPage = 1;
  listSize! : number;
      
  /*------------------------------------------
  --------------------------------------------
  Created constructor
  --------------------------------------------
  --------------------------------------------*/
  constructor(public postService: PostService) { }
      
  /**
   * Write code on Method
   *
   * @return response()
   */
  ngOnInit(): void {
    this.postService.getAllCoaches(this.currentPage - 1).subscribe(resp => {
      this.coachList = resp.content;
      this.listSize = resp.totalElements;
    }) 
  }

  deletePost(username:String){
    this.postService.delete(username).subscribe(res => {
         this.coachList = this.coachList.filter(item => item.username !== username);
         console.log('Post deleted successfully!');
    })
  }
  
}