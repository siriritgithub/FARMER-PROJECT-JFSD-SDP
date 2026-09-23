<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="adminnavbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Inbox</title>
    <%@ include file="_pagestyle.jsp" %>
</head>
<body>
<div class="page">
    <div class="card">
        <h2>Feedback Inbox</h2>

        <c:if test="${not empty message}"><div class="alert ok">${message}</div></c:if>

        <c:choose>
            <c:when test="${empty feedbacks}">
                <div class="empty">No feedback has been submitted yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>From</th>
                        <th>Role</th>
                        <th>Subject</th>
                        <th>Message</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="fb" items="${feedbacks}">
                        <tr>
                            <td>${fb.id}</td>
                            <td>
                                ${fb.name}<br/>
                                <small style="color:var(--muted);">${fb.email}</small>
                            </td>
                            <td>${fb.accessor}</td>
                            <td>${fb.subject}</td>
                            <td style="max-width:280px;">
                                ${fb.message}
                                <c:if test="${not empty fb.reply}">
                                    <div style="margin-top:8px; padding:8px; background:#f0f4f0;
                                                border-radius:6px; font-size:13px;">
                                        <b>Reply:</b> ${fb.reply}
                                    </div>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${fb.status}"><span class="badge done">Resolved</span></c:when>
                                    <c:otherwise><span class="badge open">Open</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${not fb.status}">
                                    <form action="${pageContext.request.contextPath}/resolvefeedback"
                                          method="post" style="min-width:200px;">
                                        <input type="hidden" name="id" value="${fb.id}">
                                        <textarea name="reply" rows="2"
                                                  placeholder="Optional reply (emailed to sender)"></textarea>
                                        <button class="btn" type="submit"
                                                style="margin-top:6px; padding:8px 14px;">
                                            Resolve
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
