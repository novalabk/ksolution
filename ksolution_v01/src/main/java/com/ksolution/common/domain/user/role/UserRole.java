package com.ksolution.common.domain.user.role;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.ksolution.common.domain.BaseJpaModel;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "USER_ROLE_M")
@Comment(value = "사용자 롤")
@Alias("userRole")
public class UserRole extends BaseJpaModel<Long> {
	@Id
    @Column(name = "ID", precision = 19, nullable = false)
    @Comment(value = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnPosition(1)
    private Long id;

	@Column(name = "USER_CD", length = 100, nullable = false)
    @Comment(value = "사용자 코드")
    @ColumnPosition(2)
    private String userCd;
	
	@Column(name = "ROLE_CD", length = 100, nullable = false)
    @Comment(value = "롤 코드")
    @ColumnPosition(3)
    private String roleCd;
	
	@Override
	public Long getId() {
		return id;
	}
 
}
