package com.crappycomic.emulator101

import org.junit.jupiter.api.TestInstance

/**
 * Indicates a class that contains parameterized tests.
 *
 * From https://blog.oio.de/2018/11/13/how-to-use-junit-5-methodsource-parameterized-tests-with-kotlin/
 */
@Retention(AnnotationRetention.RUNTIME)
@Target(AnnotationTarget.CLASS)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
annotation class ParameterizedTestClass
