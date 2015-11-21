package com.huoju.station.supernode.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.core.MessageSendingOperations;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.huoju.bean.ClientBean;

@Controller
public class SuperNodeController {
	private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory
			.getLogger(SuperNodeController.class);

	private List<ClientBean> clients = new ArrayList<ClientBean>();

	private MessageSendingOperations<String> template;

	@Autowired
	public SuperNodeController(MessageSendingOperations<String> template) {
		ClientBean o = new ClientBean();
		o.setName("111");
		ClientBean t = new ClientBean();
		t.setName("222");
		ClientBean th = new ClientBean();
		th.setName("333");
		clients.add(o);
		clients.add(t);
		clients.add(th);
		this.template=template;
	}

	@MessageMapping(value = "/greetings")
	public void greet(String greeting) {
		String text = "[" + new Date() + "]:" + greeting;
		System.out.println(text);
		this.template.convertAndSend("/topic/greetings", text);
	}

	@RequestMapping(value = "/test")
	public String test() {
		return "forward:/index.jsp";
	}

	/**
	 * 接受到消息后，广播出去，使用注解
	 */
	@MessageMapping(value = "/iam")
	@SendTo("/topic/clients")
	public List<ClientBean> broadcastClients() {
		for (ClientBean client : clients) {
			client.setLoginTime(new Date().toString());
		}
		System.out.println("收到消息，然后广播到/topic/clients。使用注解");
		return clients;
	}
	
	/**
	 * 定时发送
	 */
//	@Scheduled(fixedDelay = 2000)
	public void sendClientState() {
		for (ClientBean client : clients) {
			client.setLoginTime(new Date().toString());
		}
		System.out.println("定时发送");
		template.convertAndSend("/topic/clients", clients);
	}
}
