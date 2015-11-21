<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'observe.jsp' starting page</title>
    
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
    <script src="<%=basePath%>js/jquery/jquery.js"></script>
    <script src="<%=basePath%>js/sockjs/sockjs.js"></script>
    <script src="<%=basePath%>js/stomp/lib/stomp.min.js"></script>
  </head>
  
  <body>
    <script type="text/javascript">
      (function() {
        var socket = new SockJS('/ws-server/portfolio');console.log(socket);
        var stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {

            console.log('Connected ' + frame);
            //self.username(frame.headers['user-name']);

            console.log('定于客户端状态');
           // stompClient.subscribe("/app/positions", function(message) {
            //  self.portfolio().loadPositions(JSON.parse(message.body));
            //});
            stompClient.subscribe("/topic/clients", function(message) {
             // self.portfolio().processQuote(JSON.parse(message.body));
              console.log('收到推送消息:'+message);
            });
            stompClient.subscribe("/topic/greetings", {},{greetings:"nihao"},function(message) {
                // self.portfolio().processQuote(JSON.parse(message.body));
                 console.log('收到推送消息:'+message);
               });
            stompClient.send("/app/iam", {},{greetings:"nihao"},function(message) {
                // self.portfolio().processQuote(JSON.parse(message.body));
                 console.log('发送信息，等待收到广播:'+message);
               });
           // stompClient.subscribe("/user/queue/position-updates", function(message) {
           //   self.pushNotification("Position update " + message.body);
           //   self.portfolio().updatePosition(JSON.parse(message.body));
          //  });
          //  stompClient.subscribe("/user/queue/errors", function(message) {
          //    self.pushNotification("Error " + message.body);
          //  });
          }, function(error) {
            console.log("STOMP protocol error " + error);
          });
      //  var appModel = new ApplicationModel(stompClient);
      //  ko.applyBindings(appModel);

       // appModel.connect();
       // appModel.pushNotification("Trade results take a 2-3 second simulated delay. Notifications will appear.");
      })();
    </script>
  </body>
</html>
