; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i1 @eq_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @eq_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp eq i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp eq i4 %x, 0
  %i1 = icmp eq i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @ne_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @ne_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp ne i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp ne i4 %x, 0
  %i1 = icmp ne i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @eq_ne_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @eq_ne_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp eq i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp eq i4 %x, 0
  %i1 = icmp ne i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @slt_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @slt_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i4 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp slt i4 %x, 0
  %i1 = icmp slt i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

; Don't increase the instruction count.

declare void @use(i1)

define i1 @slt_zero_extra_uses(i4 %x, i4 %y) {
; CHECK-LABEL: @slt_zero_extra_uses(
; CHECK-NEXT:    [[I0:%.*]] = icmp slt i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp slt i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    call void @use(i1 [[I0]])
; CHECK-NEXT:    call void @use(i1 [[I1]])
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp slt i4 %x, 0
  %i1 = icmp slt i4 %y, 0
  %r = xor i1 %i0, %i1
  call void @use(i1 %i0)
  call void @use(i1 %i1)
  ret i1 %r
}

define i1 @sgt_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @sgt_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp sgt i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp sgt i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp sgt i4 %x, 0
  %i1 = icmp sgt i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @sgt_minus1(i4 %x, i4 %y) {
; CHECK-LABEL: @sgt_minus1(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i4 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp sgt i4 %x, -1
  %i1 = icmp sgt i4 %y, -1
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @slt_zero_sgt_minus1(i4 %x, i4 %y) {
; CHECK-LABEL: @slt_zero_sgt_minus1(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i4 [[TMP1]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp slt i4 %x, 0
  %i1 = icmp sgt i4 %y, -1
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define <2 x i1> @sgt_minus1_slt_zero_sgt(<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @sgt_minus1_slt_zero_sgt(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i4> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt <2 x i4> [[TMP1]], splat (i4 -1)
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %i1 = icmp sgt <2 x i4> %x, <i4 -1, i4 -1>
  %i0 = icmp slt <2 x i4> %y, zeroinitializer
  %r = xor <2 x i1> %i0, %i1
  ret <2 x i1> %r
}

; Don't try (crash) if the operand types don't match.

define i1 @different_type_cmp_ops(i32 %x, i64 %y) {
; CHECK-LABEL: @different_type_cmp_ops(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i64 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp1 = icmp slt i32 %x, 0
  %cmp2 = icmp slt i64 %y, 0
  %r = xor i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @test13(i8 %A, i8 %B) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[E:%.*]] = icmp ne i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[E]]
;
  %C = icmp ult i8 %A, %B
  %D = icmp ugt i8 %A, %B
  %E = xor i1 %C, %D
  ret i1 %E
}

define i1 @test14(i8 %A, i8 %B) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    ret i1 true
;
  %C = icmp eq i8 %A, %B
  %D = icmp ne i8 %B, %A
  %E = xor i1 %C, %D
  ret i1 %E
}

define i1 @xor_icmp_ptr(ptr %c, ptr %d) {
; CHECK-LABEL: @xor_icmp_ptr(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt ptr [[C:%.*]], null
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt ptr [[D:%.*]], null
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %cmp = icmp slt ptr %c, null
  %cmp1 = icmp slt ptr %d, null
  %xor = xor i1 %cmp, %cmp1
  ret i1 %xor
}

; Tests from PR70928
define i1 @xor_icmp_true_signed(i32 %a) {
; CHECK-LABEL: @xor_icmp_true_signed(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp sgt i32 %a, 5
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_true_signed_multiuse1(i32 %a) {
; CHECK-LABEL: @xor_icmp_true_signed_multiuse1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 5
; CHECK-NEXT:    call void @use(i1 [[CMP]])
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp sgt i32 %a, 5
  call void @use(i1 %cmp)
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_true_signed_multiuse2(i32 %a) {
; CHECK-LABEL: @xor_icmp_true_signed_multiuse2(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 5
; CHECK-NEXT:    call void @use(i1 [[CMP]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A]], 6
; CHECK-NEXT:    call void @use(i1 [[CMP1]])
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp sgt i32 %a, 5
  call void @use(i1 %cmp)
  %cmp1 = icmp slt i32 %a, 6
  call void @use(i1 %cmp1)
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_true_signed_commuted(i32 %a) {
; CHECK-LABEL: @xor_icmp_true_signed_commuted(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp sgt i32 %a, 5
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp1, %cmp
  ret i1 %cmp3
}
define i1 @xor_icmp_true_unsigned(i32 %a) {
; CHECK-LABEL: @xor_icmp_true_unsigned(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ugt i32 %a, 5
  %cmp1 = icmp ult i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_to_ne(i32 %a) {
; CHECK-LABEL: @xor_icmp_to_ne(
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ne i32 [[A:%.*]], 5
; CHECK-NEXT:    ret i1 [[CMP3]]
;
  %cmp = icmp sgt i32 %a, 4
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_to_ne_multiuse1(i32 %a) {
; CHECK-LABEL: @xor_icmp_to_ne_multiuse1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 4
; CHECK-NEXT:    call void @use(i1 [[CMP]])
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ne i32 [[A]], 5
; CHECK-NEXT:    ret i1 [[CMP3]]
;
  %cmp = icmp sgt i32 %a, 4
  call void @use(i1 %cmp)
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_to_icmp_add(i32 %a) {
; CHECK-LABEL: @xor_icmp_to_icmp_add(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[A:%.*]], -6
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ult i32 [[TMP1]], -2
; CHECK-NEXT:    ret i1 [[CMP3]]
;
  %cmp = icmp sgt i32 %a, 3
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
; Negative tests
; The result of ConstantRange::difference is not exact.
define i1 @xor_icmp_invalid_range(i8 %x0) {
; CHECK-LABEL: @xor_icmp_invalid_range(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X0:%.*]], -5
; CHECK-NEXT:    [[OR_COND:%.*]] = icmp ne i8 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[OR_COND]]
;
  %cmp = icmp eq i8 %x0, 0
  %cmp4 = icmp ne i8 %x0, 4
  %or.cond = xor i1 %cmp, %cmp4
  ret i1 %or.cond
}
define i1 @xor_icmp_to_ne_multiuse2(i32 %a) {
; CHECK-LABEL: @xor_icmp_to_ne_multiuse2(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 4
; CHECK-NEXT:    call void @use(i1 [[CMP]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A]], 6
; CHECK-NEXT:    call void @use(i1 [[CMP1]])
; CHECK-NEXT:    [[CMP3:%.*]] = xor i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    ret i1 [[CMP3]]
;
  %cmp = icmp sgt i32 %a, 4
  call void @use(i1 %cmp)
  %cmp1 = icmp slt i32 %a, 6
  call void @use(i1 %cmp1)
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_to_icmp_add_multiuse1(i32 %a) {
; CHECK-LABEL: @xor_icmp_to_icmp_add_multiuse1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 3
; CHECK-NEXT:    call void @use(i1 [[CMP]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A]], 6
; CHECK-NEXT:    [[CMP3:%.*]] = xor i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    ret i1 [[CMP3]]
;
  %cmp = icmp sgt i32 %a, 3
  call void @use(i1 %cmp)
  %cmp1 = icmp slt i32 %a, 6
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}
define i1 @xor_icmp_to_icmp_add_multiuse2(i32 %a) {
; CHECK-LABEL: @xor_icmp_to_icmp_add_multiuse2(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 3
; CHECK-NEXT:    call void @use(i1 [[CMP]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A]], 6
; CHECK-NEXT:    call void @use(i1 [[CMP1]])
; CHECK-NEXT:    [[CMP3:%.*]] = xor i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    ret i1 [[CMP3]]
;
  %cmp = icmp sgt i32 %a, 3
  call void @use(i1 %cmp)
  %cmp1 = icmp slt i32 %a, 6
  call void @use(i1 %cmp1)
  %cmp3 = xor i1 %cmp, %cmp1
  ret i1 %cmp3
}

define i1 @test_xor_of_bittest_ne_ne(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_ne(
; CHECK-NEXT:    [[Y:%.*]] = xor i8 [[X:%.*]], [[Y1:%.*]]
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y]], 2
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[MASK2]], 0
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %mask1 = and i8 %x, 2
  %cmp1 = icmp ne i8 %mask1, 0
  %mask2 = and i8 %y, 2
  %cmp2 = icmp ne i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_eq_eq(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_eq_eq(
; CHECK-NEXT:    [[Y:%.*]] = xor i8 [[X:%.*]], [[Y1:%.*]]
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y]], 2
; CHECK-NEXT:    [[XOR:%.*]] = icmp ne i8 [[MASK2]], 0
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %mask1 = and i8 %x, 2
  %cmp1 = icmp eq i8 %mask1, 0
  %mask2 = and i8 %y, 2
  %cmp2 = icmp eq i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_ne_eq(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_eq(
; CHECK-NEXT:    [[Y:%.*]] = xor i8 [[X:%.*]], [[Y1:%.*]]
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y]], 2
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[MASK2]], 0
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %mask1 = and i8 %x, 2
  %cmp1 = icmp ne i8 %mask1, 0
  %mask2 = and i8 %y, 2
  %cmp2 = icmp eq i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_eq_ne(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_eq_ne(
; CHECK-NEXT:    [[X:%.*]] = xor i8 [[X1:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[MASK1:%.*]] = and i8 [[X]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[MASK1]], 0
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %mask1 = and i8 %x, 2
  %cmp1 = icmp eq i8 %mask1, 0
  %mask2 = and i8 %y, 2
  %cmp2 = icmp ne i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_ne_ne_multiuse1(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_ne_multiuse1(
; CHECK-NEXT:    [[MASK1:%.*]] = and i8 [[X:%.*]], 2
; CHECK-NEXT:    call void @usei8(i8 [[MASK1]])
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y:%.*]], 2
; CHECK-NEXT:    call void @usei8(i8 [[MASK2]])
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[X]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], 2
; CHECK-NEXT:    [[XOR:%.*]] = icmp ne i8 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %mask1 = and i8 %x, 2
  call void @usei8(i8 %mask1)
  %cmp1 = icmp ne i8 %mask1, 0
  %mask2 = and i8 %y, 2
  call void @usei8(i8 %mask2)
  %cmp2 = icmp ne i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

; Negative tests

define i1 @test_xor_of_bittest_ne_ne_type_mismatch(i8 %x, i16 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_ne_type_mismatch(
; CHECK-NEXT:    [[MASK1:%.*]] = and i8 [[X:%.*]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[MASK1]], 0
; CHECK-NEXT:    [[MASK2:%.*]] = and i16 [[Y:%.*]], 2
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[MASK2]], 0
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %mask1 = and i8 %x, 2
  %cmp1 = icmp ne i8 %mask1, 0
  %mask2 = and i16 %y, 2
  %cmp2 = icmp ne i16 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_ne_ne_mask_mismatch(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_ne_mask_mismatch(
; CHECK-NEXT:    [[MASK1:%.*]] = and i8 [[X:%.*]], 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[MASK1]], 0
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y:%.*]], 2
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[MASK2]], 0
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %mask1 = and i8 %x, 4
  %cmp1 = icmp ne i8 %mask1, 0
  %mask2 = and i8 %y, 2
  %cmp2 = icmp ne i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_ne_ne_nonpower2(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_ne_nonpower2(
; CHECK-NEXT:    [[MASK1:%.*]] = and i8 [[X:%.*]], 3
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[MASK1]], 0
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[MASK2]], 0
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %mask1 = and i8 %x, 3
  %cmp1 = icmp ne i8 %mask1, 0
  %mask2 = and i8 %y, 3
  %cmp2 = icmp ne i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

define i1 @test_xor_of_bittest_ne_ne_multiuse2(i8 %x, i8 %y) {
; CHECK-LABEL: @test_xor_of_bittest_ne_ne_multiuse2(
; CHECK-NEXT:    [[MASK1:%.*]] = and i8 [[X:%.*]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[MASK1]], 0
; CHECK-NEXT:    call void @use(i1 [[CMP1]])
; CHECK-NEXT:    [[MASK2:%.*]] = and i8 [[Y:%.*]], 2
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[MASK2]], 0
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %mask1 = and i8 %x, 2
  %cmp1 = icmp ne i8 %mask1, 0
  call void @use(i1 %cmp1)
  %mask2 = and i8 %y, 2
  %cmp2 = icmp ne i8 %mask2, 0
  %xor = xor i1 %cmp1, %cmp2
  ret i1 %xor
}

declare void @usei8(i8)
