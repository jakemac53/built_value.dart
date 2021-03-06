// Copyright (c) 2017, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library values;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';

part 'values.g.dart';

/// Example of how to use built_value.
///
/// The value class must implement [Built]. It must be abstract, and have
/// fields declared as abstract getters. Finally, it must have a particular
/// constructor and factory, as shown here.
abstract class SimpleValue implements Built<SimpleValue, SimpleValueBuilder> {
  /// Example of how to make a built_value type serializable.
  ///
  /// Declare a static final [Serializer] field called `serializer`.
  /// The built_value code generator will provide the implementation. You need
  /// to do this for every type you want to serialize.
  static final Serializer<SimpleValue> serializer = _$simpleValueSerializer;

  int get anInt;

  // Only fields marked @nullable can hold null.
  @nullable
  String get aString;

  factory SimpleValue([updates(SimpleValueBuilder b)]) = _$SimpleValue;
  SimpleValue._();
}

/// Fields can use built_value classes.
abstract class CompoundValue
    implements Built<CompoundValue, CompoundValueBuilder> {
  /// Example of how to make a built_value type serializable.
  ///
  /// Declare a static final [Serializers] field called `serializer`.
  /// The built_value code generator will provide the implementation. You need
  /// to do this for every type you want to serialize.
  static final Serializer<CompoundValue> serializer = _$compoundValueSerializer;

  SimpleValue get simpleValue;
  @nullable
  ValidatedValue get validatedValue;

  factory CompoundValue([updates(CompoundValueBuilder b)]) = _$CompoundValue;
  CompoundValue._();
}

/// Additional custom validation goes in the constructor.
abstract class ValidatedValue
    implements Built<ValidatedValue, ValidatedValueBuilder> {
  static final Serializer<ValidatedValue> serializer =
      _$validatedValueSerializer;

  int get anInt;
  @nullable
  String get aString;

  factory ValidatedValue([updates(ValidatedValueBuilder b)]) = _$ValidatedValue;

  ValidatedValue._() {
    if (anInt == 7) throw new StateError('anInt may not be 7');
  }
}

/// Code can be added to value types.
abstract class ValueWithCode
    implements Built<ValueWithCode, ValueWithCodeBuilder> {
  static final int youCanHaveStaticFields = 3;

  int get anInt;
  @nullable
  String get aString;

  String get youCanWriteDerivedGetters => anInt.toString() + aString;

  factory ValueWithCode([updates(ValueWithCodeBuilder b)]) = _$ValueWithCode;
  ValueWithCode._();

  factory ValueWithCode.fromCustomFactory(int anInt) =>
      new ValueWithCode((b) => b
        ..anInt = anInt
        ..aString = 'two');
}

/// Defaults for fields go in an explicit builder class.
///
/// Normally you don't need to write your own builder class; one is generated
/// for you. But if you want to assign defaults or add custom builder code,
/// you'll need to add an explicit builder, as below.
abstract class ValueWithDefaults
    implements Built<ValueWithDefaults, ValueWithDefaultsBuilder> {
  int get anInt;
  @nullable
  String get aString;

  factory ValueWithDefaults([updates(ValueWithDefaultsBuilder b)]) =
      _$ValueWithDefaults;
  ValueWithDefaults._();
}

/// Custom builder classes must implement [Builder]. It must be abstract, and
/// have fields declared as normal public fields. Finally, it must have a
/// particular constructor and factory, as shown here.
abstract class ValueWithDefaultsBuilder
    implements Builder<ValueWithDefaults, ValueWithDefaultsBuilder> {
  /// Builder fields must be marked "@virtual". This is a language feature that
  /// allows them to be overriden.
  @virtual
  int anInt = 7;

  @nullable
  @virtual
  String aString;

  factory ValueWithDefaultsBuilder() = _$ValueWithDefaultsBuilder;
  ValueWithDefaultsBuilder._();
}

/// Example of how to use [memoized].
abstract class DerivedValue
    implements Built<DerivedValue, DerivedValueBuilder> {
  int get anInt;

  /// This getter is marked [memoized], so it will be called at most once. The
  /// result will be stored in the instance and reused.
  @memoized
  int get derivedValue => anInt + 10;

  /// This getter is marked [memoized], so it will be called at most once. The
  /// result will be stored in the instance and reused.
  @memoized
  Iterable<String> get derivedString => [toString()];

  factory DerivedValue([updates(DerivedValueBuilder b)]) = _$DerivedValue;
  DerivedValue._();
}
