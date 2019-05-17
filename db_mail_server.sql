create table users
(
    id                 integer primary key autoincrement,
    email_address_name text not null,
    domain_address     text not null,
    name               text not null,
    surname            text not null

);


insert into users (email_address_name, domain_address, name, surname)
values ('ayrat123', '@mail.ru', 'aynur', 'ilyasov');

insert into users (email_address_name, domain_address, name, surname)
values ('ayrat', '@mail.ru', 'ilnur', 'petrov');

insert into users (email_address_name, domain_address, name, surname)
values ('aksi', '@mail.ru', 'aksi', 'ivanov');

insert into users (email_address_name, domain_address, name, surname)
values ('a_k_s', '@mail.ru', 'aksi', 'ivanov');





create table messages
(
    id             integer primary key autoincrement,
    id_sender      integer references users,   --id отправителя
    id_recipient   integer references users,   --id получателя
    status_message text,                       --статус сообщения прочитанное/непрочитанное
    state_message  text,                       --состояние сообщения черновик/
    is_send        integer not null default 0 check (is_send in (0,1)),
    id_re          integer references messages  --ссылка на id предыдущего сообщения

);

alter table messages
    add trash integer not null default 0 check ( trash in (0,1,2))
;

insert into messages (id_sender, id_recipient, status_message, state_message,is_send, id_re)
values (1, 2, 'read', null,1,1);

insert into messages (id_sender, id_recipient, status_message, state_message,is_send, id_re)
values (1, 2, 'read', null, 1, 1);

insert into messages (id_sender, id_recipient, status_message, state_message,is_send, id_re)
values (2, 1, 'unread', null, 1, 1);

insert into messages (id_sender, id_recipient, status_message, state_message,is_send, id_re)
values (3, 1, 'unread', null,1,1);

insert into messages (id_sender, id_recipient, status_message, state_message,is_send, id_re)
values (3, 2, 'unread', null, 1,1);

insert into messages (id_sender, id_recipient, status_message, state_message,is_send, id_re)
values (2, 1, 'read', null, 1, 1);

insert into messages (id_sender, id_recipient, status_message, state_message,is_send)
values (2, null, null, 'draft',1);


--#1
select u1.email_address_name отправитель, u.email_address_name получатель, m.status_message
from users u
         inner join messages m on u.id = m.id_recipient
         inner join users u1 on u1.id = m.id_sender
where m.status_message = 'unread'
  and u.email_address_name = 'ayrat123'
  and m.state_message isnull;


--#2
select u1.email_address_name отправитель, u.email_address_name получатель, m.status_message
from users u
         inner join messages m on u.id = m.id_recipient
         inner join users u1 on u1.id = m.id_sender
where u.email_address_name = 'ayrat123'
  and m.state_message isnull
limit 50;


--#3
select u1.email_address_name отправитель, u.email_address_name получатель, m.status_message
from users u
         inner join messages m on u.id = m.id_recipient
         inner join users u1 on u1.id = m.id_sender
where u1.email_address_name = 'ayrat123'
limit 50;

--#4
select u.email_address_name отправитель, u1.email_address_name, m.state_message статус
from users u
         inner join messages m on u.id = m.id_sender
         left join users u1 on u1.id = m.id_recipient

where m.state_message = 'draft'


--#5 Create new letter and add it to drafts

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (2, 1, 'draft', null, 2);

--#6 Create new letter and send it

insert into messages (id_sender, id_recipient, status_message, state_message)
values (3,2,'unread','null');


--#7 Send a draft letter

update messages

set
    is_send = 1

where id = 10;

--#8 Add to draft

update messages

set
   state_message = 'draft'

where id =101;

--#9 add trash

alter table messages
    add trash integer not null default 0 check ( trash in (0,1));

--#10 deleted all draft

update messages

set
    trash = 1
where id_sender = 55 and state_message = 'draft'
;







create table messages_2
(   id integer primary key,
    id_sender integer references users,
    id_recipient integer references users,
    is_sent integer not null default 0 check ( is_sent in (0,1)),
    is_read integer not null default 0 check ( is_read in (0,1)),
    sender_status_trash integer not null default 0 check ( sender_status_trash in (0,1,2)), --# 0 - not trash, 1- trash, 2-delet
    recipient_status_trash integer not null default 0 check ( recipient_status_trash in (0,1,2)),
    name_message text,
    text_message text,
    id_re integer references messages_2
);

insert into messages_2 (id_sender, id_recipient,is_sent,is_read, id_re)
values (1, 2, 1, 1,1);

insert into messages_2 (id_sender, id_recipient,is_sent,is_read, id_re)
values (1, 2, 1,0 ,1);

insert into messages_2 (id_sender, id_recipient,is_sent,is_read, id_re)
values (2, 1, 1,0,  1);
insert into messages_2 (id_sender, id_recipient,is_sent,is_read, id_re)
values (2, 1, 1,0,  1);



--#11 deleted all draft
UPDATE
    messages_2
SET
    sender_status_trash = 1
WHERE
    id_sender = 8
AND
    is_sent = 0;

--#12 deleted all inbox

UPDATE
    messages_2
SET
    recipient_status_level= 1
WHERE
    iid_recipient = 55
AND
    is_sent = 1;



--#12  deleted all trash

update messages_2

set sender_status_trash = 2

where  sender_status_trash = 1 and id_sender = 55

update  messages_2

set  recipient_status_trash = 2

where recipient_status_trash = 1 and id_sender = 55


--#13  statistic


select  count(id_recipient) inbox from messages_2
 where id_recipient = 55  and is_sent = 1 and  recipient_status_trash = 0

union

select count(id_recipient) unread from messages_2
    where id_recipient = 55 and is_sent = 1 and recipient_status_trash = 0 and is_read = 0


union

select count(id_sender) sent from messages_2
    where id_sender = 55 and is_sent = 1

union


select count(id_sender) draft from messages_2
    where id_sender = 55 and is_sent = 0 and sender_status_trash = 0


--#14




