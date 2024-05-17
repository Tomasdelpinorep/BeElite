import { Component, TemplateRef } from '@angular/core';
import { UserDto } from '../../models/user-dto.intercace';
import { PostService } from '../../service/post/post.service';
import { environment } from '../../environment/environtments';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-coaches',
  standalone: false,
  templateUrl: './coaches.component.html',
  styleUrl: './coaches.component.scss',
})
export class AdminCoachesComponent {

  closeResult = "";
  coachList: UserDto[] = [];
  currentPage = 1;
  listSize!: number;
  defaultProfilePicUrl: String = environment.defaultProfilePicUrl;
  selectedCoachUsername: String = "";

  /*------------------------------------------
  --------------------------------------------
  Created constructor
  --------------------------------------------
  --------------------------------------------*/
  constructor(public postService: PostService, private modalService: NgbModal) { }

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

  deleteCoach() {
    this.postService.delete(this.selectedCoachUsername).subscribe(res => {
      this.coachList = this.coachList.filter(item => item.username !== this.selectedCoachUsername);
      console.log('Post deleted successfully!');
    })
  }

  openConfirmationDialog(content: TemplateRef<any>, coachUsername: String) {
    this.selectedCoachUsername = coachUsername;

    this.modalService.open(content, { ariaLabelledBy: 'modal-basic-title' }).result.then(
      (result: any) => {
        this.closeResult = `Closed with: ${result}`;
      },
      (reason: any) => {
        this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
      },
    );
  }

  private getDismissReason(reason: any): string {
    switch (reason) {
      case ModalDismissReasons.ESC:
        return 'by pressing ESC';
      case ModalDismissReasons.BACKDROP_CLICK:
        return 'by clicking on a backdrop';
      default:
        return `with: ${reason}`;
    }
  }

}