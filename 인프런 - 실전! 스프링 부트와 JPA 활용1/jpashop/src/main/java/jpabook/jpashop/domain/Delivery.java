package jpabook.jpashop.domain;

import lombok.Getter;
import lombok.Setter;
import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@Getter @Setter
public class Delivery {

    @Id @GeneratedValue
    @Column(name="delivery_id")
    private Long id;

    @OneToOne(mappedBy = "delivery", fetch = LAZY)
    private Order order;

    @Embedded
    private Address address;

    @Enumerated(EnumType.STRING)
    private DeliveryStatus status; //배송상태
    //EnumType의 기본값이 ORDINAL, 컬럼이 숫자로 들어감
    //EnumType.ORDINAL > 중간에 데이터가 추가되면 오류 발생함,사용 금지

}
