package com.ksolution.common.domain.user.auth;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.ksolution.common.domain.BaseJpaModel;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@Table(name = "USER_AUTH_M")
public class UserAuth extends BaseJpaModel<Long> {
	
	@Id
    @Column(name = "ID", precision = 19, nullable = false)
    @Comment(value = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnPosition(1)
    private Long id;

    @Column(name = "USER_CD")
    @ColumnPosition(2)
    private String userCd;

    @Column(name = "GRP_AUTH_CD")
    @ColumnPosition(3)
    private String grpAuthCd;

    @Override
    public Long getId() {
        return id;
    }

}
