/*
 * Copyright (c) 2012, dooApp <contact@dooapp.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of dooApp nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package model.helper

import javafx.beans.Observable
import javafx.beans.binding.ObjectBinding
import javafx.beans.value.ObservableValue
import javafx.collections.ListChangeListener.Change
import javafx.collections.ObservableList

import static util.CollectionsUtil.*

/**
 * This Class provides most of the functionality needed to implement a Binding of an {@link Object} with complex
 * dependencies.
 * <br>
 * To provide a concrete implementation of this class, the method {@link javafx.beans.binding
 * .ObjectBinding#computeValue()}
 * has to be implemented to calculate the value of this binding based on the current state of the dependencies. It is
 * called when {@link ObjectBinding#get()} is called for an invalid binding.
 * <br>You also need to implement the {@link FXObjectBinding#configure()} method. This method will be called every
 * time the binding is becoming invalid. You will add an remove dependencies by calling {@link
 * FXObjectBinding#addObservable(javafx.beans.Observable...)}   <br><br><br>
 * You can get and example at {@link FXBooleanBinding}    <br><br>
 *
 * @author <a href="mailto:christophe@dooapp.com">Christophe DUFOUR</a>
 */
abstract class FXBinding<T> extends ObjectBinding<T>{
	
	ObservableList<Observable> dependencies
	
	ObjectBinding<T> nested
	
	new() {
		configure()
	}
	
	def protected final void addObservable(Observable... observables) {
		getDependencies().addAll(observables)
	}
	
	def protected abstract void configure();
	
	override def void dispose() {
		getDependencies().clear()
	}
	
	override ObservableList<Observable> getDependencies() {
		if (dependencies === null) {
			dependencies = newObservableList()
			dependencies.addListener[ Change<? extends Observable> change |
				nested = new ObjectBinding<T>() {
					override protected void onInvalidating() {
						FXBinding.this.invalidate()
					}
					
					override protected T computeValue() {
						return compute();
					}
				}
				nested.bind(dependencies)
			]
		}
		return dependencies
	}
	
	override protected void onInvalidating() {
		reconfigure()
	}
	
	def private void reconfigure() {
		dispose()
		configure();
	}
	
	override protected final T computeValue() {
		reconfigure()
		return nested.get()
	}
	
	def protected abstract T compute()
	
	
	def static<V, A extends ObservableValue<?>, B extends ObservableValue<V>> FXObjectBinding<V> nestedBinding(A a, (A)=>B f1) {
		return new FXObjectBinding<V>() {
			override configure() {
				try {
					val b = f1.apply(a)
					addObservable(a, b)
				} catch (NullPointerException ignored) {}
			}
			
			override compute() {
				return try {
					val b = f1.apply(a)
					b.value
				} catch(NullPointerException npe) {
					null
				}
			}
		}
	}
	
	def static<V, A extends ObservableValue<?>, B extends ObservableValue<?>, C extends ObservableValue<V>> FXObjectBinding<V> nestedBinding(A a, (A)=>B f1, (B)=>C f2) {
		return new FXObjectBinding<V> {
			override configure() {
				try {
					val b = f1.apply(a)
					val c = f2.apply(b)
					addObservable(a, b, c)
				} catch (NullPointerException ignored) {}
			}
			
			override compute() {
				return try {
					val b = f1.apply(a)
					val c = f2.apply(b)
					c.value
				} catch (NullPointerException npe) {
					null
				}
			}
		}
	}
	
	def static <V, A extends ObservableValue<?>, B extends ObservableValue<?>, C extends ObservableValue<?>, D extends ObservableValue<V>> FXObjectBinding<V> nestedBinding(A a, (A)=>B f1, (B)=>C f2, (C)=>D f3) {
		return new FXObjectBinding<V> {
			override configure() {
				try {
					val b = f1.apply(a)
					val c = f2.apply(b)
					val d = f3.apply(c)
					addObservable(a, b, c, d)
				} catch (NullPointerException ignored) {}
			}
			
			override compute() {
				return try {
					val b = f1.apply(a)
					val c = f2.apply(b)
					val d = f3.apply(c)
					d.value
				} catch (NullPointerException npe) {
					null
				}
			}
		}
	}
}