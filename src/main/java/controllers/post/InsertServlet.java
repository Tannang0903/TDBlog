package controllers.post;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import controllers.BaseServlet;
import core.Validator.ValidateResult;
import core.Validator.Validator;
import models.BO.PostBO;
import models.BO.TagBO;
import models.Bean.Post;
import models.Bean.Tag;

@WebServlet("/posts/insert")
public class InsertServlet extends BaseServlet {
	private TagBO tagBO;
	private PostBO postBO;
	public InsertServlet() {
		tagBO = new TagBO();
		postBO = new PostBO();
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ArrayList<Tag> tags = tagBO.getAll();
		
		request.setAttribute("tags", tags);
		request.getRequestDispatcher("/views/post/insert.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		super.doPost(request, response);
		
		String name = (String)request.getParameter("title");
		String content = (String)request.getParameter("content");
		String tagID = (String)request.getParameter("tag");
		
		Post post = new Post();
		post.setName(name);
		post.setContent(content);
		post.setTagID(tagID);
		post.setAuthorID(this.authContext.getClaim("UserID").getValue());
		
		ValidateResult modelState = Validator.validate(post);
		if (modelState.isFailure()) {
			request.setAttribute("validation-error", modelState.getMessages());
			doGet(request, response);
		}else {
			boolean result = postBO.add(post);
			if (result) {
				request.setAttribute("success", true);
			}else {
				request.setAttribute("error", "Thêm bài viết thất bại");
			}
		}
		doGet(request, response);
	}

}
