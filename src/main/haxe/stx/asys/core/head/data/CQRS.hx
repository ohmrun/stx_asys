package stx.asys.core.head.data;

enum CQRS<R,E>{
  Read(r:R);
  Edit(e:E);
}

