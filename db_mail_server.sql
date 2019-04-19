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
    id_re          integer references messages --ссылка на id предыдущего сообщения

);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (1, 2, 'read', null, null);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (1, 2, 'read', null, 1);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (2, 1, 'unread', null, 1);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (3, 1, 'unread', null, null);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (3, 2, 'unread', null, null);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (2, 1, 'read', null, 1);

insert into messages (id_sender, id_recipient, status_message, state_message, id_re)
values (2, null, null, 'draft', null);


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
